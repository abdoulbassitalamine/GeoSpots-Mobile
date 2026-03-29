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
    final notifier = ref.read(placeDetailsViewModelProvider(placeId).notifier);
    final activeAccessRight = ref.watch(activeCollectionAccessRightProvider);
    final activeSharedToken = ref.watch(activeSharedAccessTokenProvider);
    final effectiveReadOnly =
        readOnly || activeAccessRight == ShareAccessRight.read;
    final isSharedContext =
        activeAccessRight != null ||
        (activeSharedToken != null && activeSharedToken.isNotEmpty);
    final useSharedImageToken =
        activeAccessRight != null ||
        (activeSharedToken != null && activeSharedToken.isNotEmpty);
    final popResult = state.shouldRefreshParent ? true : null;

    return CustomScrollView(
      slivers: [
        if (state.place != null)
          PlaceDetailsHeader(
            place: state.place!,
            onBack: () => Navigator.of(context).pop(popResult),
            useSharedImageToken: useSharedImageToken,
            isReadOnly: effectiveReadOnly,
          )
        else
          PlaceDetailsFallbackHeader(
            onBack: () => Navigator.of(context).pop(popResult),
          ),
        if (state.isLoading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: GSCircularLoader()),
          )
        else if (state.loadErrorMessage != null)
          SliverFillRemaining(
            hasScrollBody: false,
            child: GSErrorState(
              title: 'Impossible de charger le lieu',
              message: state.loadErrorMessage!,
              onRetry: () => notifier.loadPlace(placeId),
              retryLabel: 'Réessayer',
            ),
          )
        else if (state.place == null)
          SliverFillRemaining(
            hasScrollBody: false,
            child: GSErrorState(
              title: 'Lieu introuvable',
              message: 'Ce lieu est introuvable ou n’est plus accessible.',
              onRetry: () => notifier.loadPlace(placeId),
              retryLabel: 'Réessayer',
            ),
          )
        else
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Column(
                children: [
                  PlaceDetailsContent(place: state.place!),
                  const SizedBox(height: GSSpacing.xl3),
                  PlaceDetailsActions(
                    place: state.place!,
                    placeId: placeId,
                    readOnly: effectiveReadOnly,
                    showShareAction: !isSharedContext,
                  ),
                  const SizedBox(height: GSSpacing.xl3),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
