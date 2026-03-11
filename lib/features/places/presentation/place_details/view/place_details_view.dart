import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';
import 'package:geo_spots/features/collections/presentation/view_model/shared_access_session.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/place_details_view_model.dart';
import '../wigets/place_details_actions.dart';
import '../wigets/place_details_content.dart';
import '../wigets/place_details_header.dart';

class PlaceDetailsView extends ConsumerWidget {
  const PlaceDetailsView({
    super.key,
    required this.placeId,
    this.readOnly = false,
  });
  final String placeId;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      placeDetailsViewModelProvider(
        placeId,
      ).select((state) => state.snackbarMessage),
      (previous, next) {
        if (next == null || previous == next) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }
          next.show(context);
          ref
              .read(placeDetailsViewModelProvider(placeId).notifier)
              .consumeSnackbar();
        });
      },
    );

    final state = ref.watch(placeDetailsViewModelProvider(placeId));
    final activeAccessRight = ref.watch(activeCollectionAccessRightProvider);
    final effectiveReadOnly =
        readOnly || activeAccessRight == ShareAccessRight.read;

    if (state.isLoading) {
      return const Center(child: GSCircularLoader());
    }

    if (state.loadErrorMessage != null) {
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
                state.loadErrorMessage!,
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
              PlaceDetailsActions(
                place: state.place!,
                placeId: placeId,
                readOnly: effectiveReadOnly,
              ),
              const SizedBox(height: GSSpacing.xl3),
            ],
          ),
        ),
      ],
    );
  }
}
