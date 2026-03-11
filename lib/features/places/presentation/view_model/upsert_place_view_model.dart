import 'package:geo_spots/core/constants/app_constants.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';
import 'package:geo_spots/features/collections/presentation/view_model/shared_access_session.dart';
import 'package:geo_spots/shared/design_system/widgets/common/gs_protected_network_image.dart';
import 'package:geo_spots/shared/design_system/widgets/snackbar/snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/utils/validator/validator.dart';
import '../../domain/entity/place_upsert_payload.dart';
import '../../domain/use_case/places_use_cases.dart';
import 'upsert_place_state.dart';

part 'upsert_place_view_model.g.dart';

@riverpod
class UpsertPlaceViewModel extends _$UpsertPlaceViewModel {
  final requiredValidator = ValidatorRequired();
  final latitudeValidator = ValidatorLatitude();
  final longitudeValidator = ValidatorLongitude();

  late final titleValidators = Validators(validators: [requiredValidator]);
  late final latitudeValidators = Validators(
    validators: [requiredValidator, latitudeValidator],
  );
  late final longitudeValidators = Validators(
    validators: [requiredValidator, longitudeValidator],
  );
  String? _initialImageUrl;

  @override
  UpsertPlaceState build(String placeId) {
    ref.watch(getPlaceByIdUseCaseProvider);
    requiredValidator.withErrorMessage('Ce champ est obligatoire');
    latitudeValidator.withErrorMessage('Latitude invalide (-90 a 90)');
    longitudeValidator.withErrorMessage('Longitude invalide (-180 a 180)');

    // Mode édition
    if (placeId != kPlaceCreationId) {
      Future.microtask(() => _loadPlace(placeId));
      return UpsertPlaceState(placeId: placeId, isLoading: true);
    }

    // Mode création
    return UpsertPlaceState(placeId: placeId);
  }

  Future<void> _loadPlace(String placeId) async {
    state = state.copyWith(isLoading: true);

    final getPlaceById = ref.read(getPlaceByIdUseCaseProvider);
    final result = await getPlaceById(placeId);
    switch (result) {
      case Ok(value: final place):
        if (place == null) {
          state = state.copyWith(
            isLoading: false,
            loadErrorMessage: 'Lieu non trouvé',
          );
          return;
        }

        _initialImageUrl = place.imageUrl;
        state = state.copyWith(
          title: place.title,
          description: place.description,
          tags: place.tags,
          imageUrl: place.imageUrl,
          position: place.hasCoordinates
              ? LatLng(place.latitude!, place.longitude!)
              : null,
          manualLatitude: place.latitude?.toStringAsFixed(6) ?? '',
          manualLongitude: place.longitude?.toStringAsFixed(6) ?? '',
          address: place.address ?? '',
          isLoading: false,
          loadErrorMessage: null,
        );

        GsLogger().d('Place loaded for editing: ${place.id}');
        GsLogger().d('Place loaded : $place');
      case Err(error: final error):
        state = state.copyWith(
          isLoading: false,
          loadErrorMessage: 'Erreur lors du chargement',
        );
        GsLogger().e(error);
    }
  }

  Future<UpsertPlaceState> updateState(UpsertPlaceState newState) async {
    state = newState;
    return state;
  }

  Future<void> reload() async {
    final placeId = state.placeId;
    if (!state.isEditMode || placeId == null) {
      return;
    }
    await _loadPlace(placeId);
  }

  bool get isStep0Valid => titleValidators.execute(state.title).isEmpty;
  bool get _hasManualCoordinatesDraft =>
      state.manualLatitude.trim().isNotEmpty ||
      state.manualLongitude.trim().isNotEmpty;

  String? get latitudeError {
    if (!_hasManualCoordinatesDraft) return null;
    return latitudeValidators
        .executeWithPriorityMessage(state.manualLatitude)
        .message;
  }

  String? get longitudeError {
    if (!_hasManualCoordinatesDraft) return null;
    return longitudeValidators
        .executeWithPriorityMessage(state.manualLongitude)
        .message;
  }

  bool get _manualCoordinatesValid =>
      latitudeError == null && longitudeError == null;

  bool get isStep1Valid => state.position != null && _manualCoordinatesValid;

  bool isStepValid(int index) {
    switch (index) {
      case 0:
        return isStep0Valid;
      case 1:
        return isStep1Valid;
      default:
        return true;
    }
  }

  Future<void> getCurrentPosition({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(isLoading: true);
    }

    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition();
      state = state.copyWith(
        position: LatLng(position.latitude, position.longitude),
        manualLatitude: position.latitude.toStringAsFixed(6),
        manualLongitude: position.longitude.toStringAsFixed(6),
        isLoading: false,
      );

      GsLogger().d('Position: ${position.latitude}, ${position.longitude}');
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        snackbarMessage: const GSSnackbarMessage(
          message: 'Impossible d\'obtenir la position actuelle',
          type: GSSnackbarType.error,
        ),
      );
      GsLogger().e(e);
    }
  }

  void setPosition(LatLng position) {
    state = state.copyWith(
      position: position,
      manualLatitude: position.latitude.toStringAsFixed(6),
      manualLongitude: position.longitude.toStringAsFixed(6),
    );
  }

  void updateManualCoordinates({
    required String latitude,
    required String longitude,
  }) {
    state = state.copyWith(
      manualLatitude: latitude,
      manualLongitude: longitude,
    );

    if (!_hasManualCoordinatesDraft) {
      return;
    }

    final latError = latitudeError;
    final lonError = longitudeError;

    if (latError == null && lonError == null) {
      final lat = _parseCoordinate(latitude);
      final lon = _parseCoordinate(longitude);
      if (lat != null && lon != null) {
        state = state.copyWith(position: LatLng(lat, lon));
      }
    }
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        state = state.copyWith(imageUrl: image.path);
      }
      GsLogger().d('Image: ${image?.path}');
    } on Exception catch (e) {
      state = state.copyWith(
        snackbarMessage: const GSSnackbarMessage(
          message: 'Erreur lors du choix de l\'image',
          type: GSSnackbarType.error,
        ),
      );
      GsLogger().e(e);
    }
  }

  Future<bool> savePlace() async {
    if (!isStep0Valid || !isStep1Valid) {
      state = state.copyWith(
        snackbarMessage: const GSSnackbarMessage(
          message: 'Veuillez remplir tous les champs obligatoires',
          type: GSSnackbarType.warning,
        ),
      );
      return false;
    }

    state = state.copyWith(isSaving: true, snackbarMessage: null);
    final updatePlace = ref.read(updatePlaceUseCaseProvider);
    final createPlace = ref.read(createPlaceUseCaseProvider);
    final uploadPlaceImage = ref.read(uploadPlaceImageUseCaseProvider);
    final deletePlaceImage = ref.read(deletePlaceImageUseCaseProvider);
    final latitude = state.position!.latitude;
    final longitude = state.position!.longitude;
    final payload = PlaceUpsertPayload(
      title: state.title.trim(),
      description: state.description.trim(),
      latitude: latitude,
      longitude: longitude,
      imageUrl: _resolvedRemoteImageUrl(state.imageUrl),
      tags: state.tags,
    );
    final imagePath = state.imageUrl;

    final upsertResult = state.isEditMode
        ? await updatePlace(state.placeId!, payload)
        : await createPlace(payload);

    String persistedPlaceId;
    switch (upsertResult) {
      case Ok(value: final place):
        persistedPlaceId = place.id;
      case Err(error: final error):
        state = state.copyWith(
          isSaving: false,
          snackbarMessage: GSSnackbarMessage(
            message: state.isEditMode
                ? 'Erreur lors de la mise à jour du lieu'
                : 'Erreur lors de la création du lieu',
            type: GSSnackbarType.error,
          ),
        );
        GsLogger().e(error);
        return false;
    }

    if (_isLocalImagePath(imagePath)) {
      final imageResult = await uploadPlaceImage(
        id: persistedPlaceId,
        imagePath: imagePath!,
      );
      switch (imageResult) {
        case Ok(value: final place):
          await _evictPlaceImageCache(
            persistedPlaceId,
            imageUrl: place.imageUrl,
          );
          break;
        case Err(error: final error):
          state = state.copyWith(
            isSaving: false,
            snackbarMessage: const GSSnackbarMessage(
              message: 'Erreur lors de l\'upload de l\'image',
              type: GSSnackbarType.error,
            ),
          );
          GsLogger().e(error);
          return false;
      }
    } else if (state.isEditMode &&
        _initialImageUrl != null &&
        imagePath == null) {
      final deleteImageResult = await deletePlaceImage(persistedPlaceId);
      switch (deleteImageResult) {
        case Ok():
          await _evictPlaceImageCache(
            persistedPlaceId,
            imageUrl: _initialImageUrl,
          );
          break;
        case Err(error: final error):
          state = state.copyWith(
            isSaving: false,
            snackbarMessage: const GSSnackbarMessage(
              message: 'Erreur lors de la suppression de l\'image',
              type: GSSnackbarType.error,
            ),
          );
          GsLogger().e(error);
          return false;
      }
    }

    state = state.copyWith(isSaving: false);
    ref.invalidate(authenticationRepositoryProvider);
    return true;
  }

  double? _parseCoordinate(String raw) {
    final normalized = raw.trim().replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  String? _resolvedRemoteImageUrl(String? value) {
    if (value == null) {
      return null;
    }
    final normalized = value.trim();
    if (normalized.isEmpty || _isLocalImagePath(normalized)) {
      return null;
    }
    return normalized;
  }

  bool _isLocalImagePath(String? value) {
    if (value == null) {
      return false;
    }
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) {
      return false;
    }
    return (normalized.startsWith('/') &&
            !normalized.startsWith('/api/images/')) ||
        normalized.startsWith('file://') ||
        (!normalized.startsWith('http://') &&
            !normalized.startsWith('https://') &&
            !normalized.startsWith('/api/images/'));
  }

  void consumeSnackbar() {
    if (state.snackbarMessage != null) {
      state = state.copyWith(snackbarMessage: null);
    }
  }

  Future<void> _evictPlaceImageCache(String placeId, {String? imageUrl}) async {
    final sharedToken = ref.read(activeSharedAccessTokenProvider);
    final remoteImageUrl = imageUrl?.trim().isNotEmpty ?? false
        ? imageUrl!.trim()
        : '/api/images/$placeId';

    await gsEvictProtectedImage(ref, remoteImageUrl);
    if (sharedToken != null && sharedToken.isNotEmpty) {
      await gsEvictProtectedImage(
        ref,
        remoteImageUrl,
        useSharedTokenQueryParam: true,
        sharedToken: sharedToken,
      );
    }
  }
}
