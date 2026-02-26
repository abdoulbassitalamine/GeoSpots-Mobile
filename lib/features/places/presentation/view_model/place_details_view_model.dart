import 'package:geo_spots/core/utils/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/use_case/places_use_cases.dart';
import 'place_details_state.dart';

part 'place_details_view_model.g.dart';

@riverpod
class PlaceDetailsViewModel extends _$PlaceDetailsViewModel {
  @override
  PlaceDetailsState build(String placeId) {
    Future.microtask(() => loadPlace(placeId));
    return const PlaceDetailsState(isLoading: true);
  }

  Future<void> loadPlace(String placeId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final getPlaceById = ref.read(getPlaceByIdUseCaseProvider);
    final result = await getPlaceById(placeId);

    switch (result) {
      case Ok(value: final remotePlace):
        if (remotePlace == null) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Lieu non trouvé',
          );
          return;
        }

        state = state.copyWith(place: remotePlace, isLoading: false);
      case Err():
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erreur lors du chargement du lieu',
        );
    }
  }

  Future<void> deletePlace() async {
    if (state.place == null) return;

    final deletePlace = ref.read(deletePlaceUseCaseProvider);
    final result = await deletePlace(state.place!.id);

    switch (result) {
      case Ok():
        state = state.copyWith(place: null);
      case Err():
        state = state.copyWith(errorMessage: 'Erreur lors de la suppression');
    }
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
        state = state.copyWith(errorMessage: 'Erreur lors du partage');
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
