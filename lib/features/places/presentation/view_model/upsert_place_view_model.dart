import 'package:geo_spots/core/constants/app_constants.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/utils/validator/validator.dart';
import '../../domain/repository/places_repository.dart';
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

  @override
  UpsertPlaceState build(String placeId) {
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

    try {
      final repository = ref.read(placesRepositoryProvider);
      final place = await repository.getPlaceById(placeId);

      if (place == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Lieu non trouvé',
        );
        return;
      }

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
      );

      GsLogger().d('Place loaded for editing: ${place.id}');
      GsLogger().d('Place loaded : $place');
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement',
      );
      GsLogger().e(e);
    }
  }

  Future<UpsertPlaceState> updateState(UpsertPlaceState newState) async {
    state = newState;
    return state;
  }

  bool get isStep0Valid => titleValidators.execute(state.title).isEmpty;
  bool get _hasManualCoordinatesDraft =>
      state.manualLatitude.trim().isNotEmpty ||
      state.manualLongitude.trim().isNotEmpty;

  String? get latitudeError {
    if (!_hasManualCoordinatesDraft) return null;
    return latitudeValidators.executeWithPriorityMessage(state.manualLatitude).message;
  }

  String? get longitudeError {
    if (!_hasManualCoordinatesDraft) return null;
    return longitudeValidators.executeWithPriorityMessage(state.manualLongitude).message;
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
        errorMessage: 'Impossible d\'obtenir la position',
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
      state = state.copyWith(errorMessage: 'Erreur lors du choix de l\'image');
      GsLogger().e(e);
    }
  }

  Future<void> savePlace() async {
    if (!isStep0Valid || !isStep1Valid) {
      state = state.copyWith(
        errorMessage: 'Veuillez remplir tous les champs obligatoires',
      );
      return;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      // TODO(dev): Implement save via repository.
      // final repository = ref.read(placesRepositoryProvider);

      if (state.isEditMode) {
        // Mode modification
        // await repository.updatePlace(state.placeId!, ...);
        GsLogger().d('Updating place: ${state.placeId}');
      } else {
        // Mode création
        // await repository.createPlace(...);
        GsLogger().d('Creating new place');
      }

      await Future<void>.delayed(const Duration(seconds: 1));
      state = state.copyWith(isSaving: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: state.isEditMode
            ? 'Erreur lors de la mise à jour'
            : 'Erreur lors de la création',
      );
      GsLogger().e(e);
    }
  }

  double? _parseCoordinate(String raw) {
    final normalized = raw.trim().replaceAll(',', '.');
    return double.tryParse(normalized);
  }
}
