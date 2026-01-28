import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/utils/validator/validator.dart';
import '../../domain/repository/places_repository.dart';
import 'add_place_state.dart';

part 'add_place_view_model.g.dart';

@riverpod
class AddPlaceViewModel extends _$AddPlaceViewModel {
  // Validators
  final requiredValidator = ValidatorRequired();

  // Form validators
  late final titleValidators = Validators(validators: [requiredValidator]);
  late final positionValidators = Validators(validators: [requiredValidator]);

  @override
  AddPlaceState build() {
    return const AddPlaceState();
  }

  Future<AddPlaceState> updateState(AddPlaceState state) async {
    this.state = state;
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

      GsLogger().d("=" * 50);

      GsLogger().d('Position: ${position.latitude}, ${position.longitude}');

      GsLogger().d("=" * 50);
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
      GsLogger().d("=" * 50);
      GsLogger().d('Image: ${image?.path}');
      GsLogger().d("=" * 50);
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
      // await repository.createPlace(...);

      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Erreur lors de l\'enregistrement',
      );
    }
  }
}
