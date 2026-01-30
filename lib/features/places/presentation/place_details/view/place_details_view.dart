import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/place_details_view_model.dart';
import '../wigets/place_details_actions.dart';
import '../wigets/place_details_content.dart';
import '../wigets/place_details_header.dart';

class PlaceDetailsView extends ConsumerWidget {
  final String placeId;

  const PlaceDetailsView({super.key, required this.placeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(placeDetailsViewModelProvider(placeId));

    if (state.isLoading) {
      return const Center(child: GSCircularLoader());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(GSSpacing.xl3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: GSColors.danger600,
              ),
              const SizedBox(height: GSSpacing.xl),
              Text(
                state.errorMessage!,
                style: GSTypography.bodyDefaultLarge.copyWith(
                  color: GSColors.danger600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state.place == null) {
      return const Center(child: Text('Lieu introuvable'));
    }

    return CustomScrollView(
      slivers: [
        PlaceDetailsHeader(place: state.place!),
        SliverToBoxAdapter(
          child: Column(
            children: [
              PlaceDetailsContent(place: state.place!),
              const SizedBox(height: GSSpacing.xl3),
              PlaceDetailsActions(place: state.place!, placeId: placeId),
              const SizedBox(height: GSSpacing.xl3),
            ],
          ),
        ),
      ],
    );
  }
}
