import 'package:geo_spots/core/logger/gs_logger.dart';
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
  late final titleValidators = Validators(validators: [requiredValidator]);
  late final positionValidators = Validators(validators: [requiredValidator]);

  @override
  UpsertPlaceState build(String placeId) {
    // Si c'est une modification, charger les données
    if (placeId != 'new') {
      Future.microtask(() => _loadPlace(placeId));
      return UpsertPlaceState(placeId: placeId, isLoading: true);
    }

    // Sinon, état vide pour création
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
        address: place.address ?? '',
        isLoading: false,
      );

      GsLogger().d('Place loaded for editing: ${place.id}');
      GsLogger().d('Place loaded : ${place}');
    } catch (e) {
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
  bool get isStep1Valid => state.position != null;

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

  Future<void> getCurrentPosition() async {
    state = state.copyWith(isLoading: true);

    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition();
      state = state.copyWith(
        position: LatLng(position.latitude, position.longitude),
        isLoading: false,
      );

      GsLogger().d('Position: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Impossible d\'obtenir la position',
      );
      GsLogger().e(e);
    }
  }

  void setPosition(LatLng position) {
    state = state.copyWith(position: position);
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        state = state.copyWith(imageUrl: image.path);
      }
      GsLogger().d('Image: ${image?.path}');
    } catch (e) {
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
      // TODO: Implémenter la sauvegarde via le repository
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

      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: state.isEditMode
            ? 'Erreur lors de la mise à jour'
            : 'Erreur lors de la création',
      );
      GsLogger().e(e);
    }
  }
}
