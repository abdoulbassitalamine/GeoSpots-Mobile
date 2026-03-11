import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/shared/design_system/widgets/snackbar/snackbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/use_case/places_use_cases.dart';
import 'place_details_state.dart';

part 'place_details_view_model.g.dart';

@riverpod
class PlaceDetailsViewModel extends _$PlaceDetailsViewModel {
  @override
  PlaceDetailsState build(String placeId) {
    ref.watch(getPlaceByIdUseCaseProvider);
    Future.microtask(() => loadPlace(placeId));
    return const PlaceDetailsState(isLoading: true);
  }

  Future<void> loadPlace(String placeId) async {
    state = state.copyWith(isLoading: true, loadErrorMessage: null);

    final getPlaceById = ref.read(getPlaceByIdUseCaseProvider);
    final result = await getPlaceById(placeId);

    switch (result) {
      case Ok(value: final remotePlace):
        if (remotePlace == null) {
          state = state.copyWith(
            isLoading: false,
            loadErrorMessage: 'Lieu non trouvé',
          );
          return;
        }

        state = state.copyWith(
          place: remotePlace,
          isLoading: false,
          loadErrorMessage: null,
        );
      case Err():
        state = state.copyWith(
          isLoading: false,
          loadErrorMessage: 'Erreur lors du chargement du lieu',
        );
    }
  }

  Future<bool> deletePlace() async {
    if (state.place == null) {
      return false;
    }

    final deletePlace = ref.read(deletePlaceUseCaseProvider);
    final result = await deletePlace(state.place!.id);

    switch (result) {
      case Ok():
        state = state.copyWith(place: null, shouldRefreshParent: true);
        return true;
      case Err():
        state = state.copyWith(
          snackbarMessage: const GSSnackbarMessage(
            message: 'Impossible de supprimer ce lieu',
            type: GSSnackbarType.error,
          ),
        );
        return false;
    }
  }

  Future<void> refreshAfterUpdate(String placeId) async {
    state = state.copyWith(shouldRefreshParent: true);
    await loadPlace(placeId);
  }

  Future<void> sharePlace() async {
    final place = state.place;
    if (place == null) {
      return;
    }

    final sharePlace = ref.read(sharePlaceUseCaseProvider);
    final result = await sharePlace(id: place.id, canWrite: false);

    switch (result) {
      case Ok(value: final value):
        final shareText = StringBuffer()
          ..writeln(place.title)
          ..writeln(value.url);
        if (value.expiresAt != null) {
          shareText.writeln('Expire le ${_formatDate(value.expiresAt!)}');
        }

        await SharePlus.instance.share(
          ShareParams(
            subject: 'Partage du lieu: ${place.title}',
            text: shareText.toString(),
          ),
        );
      case Err():
        state = state.copyWith(
          snackbarMessage: const GSSnackbarMessage(
            message: 'Impossible de partager ce lieu',
            type: GSSnackbarType.error,
          ),
        );
    }
  }

  void consumeSnackbar() {
    if (state.snackbarMessage != null) {
      state = state.copyWith(snackbarMessage: null);
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
