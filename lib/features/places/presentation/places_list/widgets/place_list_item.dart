import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../../domain/entity/place_entity.dart';
import '../../helpers/place_action_handler.dart';

class PlaceListItem extends ConsumerWidget {
  const PlaceListItem({
    super.key,
    required this.place,
    required this.onTap,
    this.useSharedImageToken = false,
  });

  final PlaceEntity place;
  final VoidCallback onTap;
  final bool useSharedImageToken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GSPremiumPanel(
      onTap: onTap,
      padding: const EdgeInsets.all(GSSpacing.xl),
      borderColor: GSColors.neutral150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlaceThumbnail(
                imageUrl: place.imageUrl,
                useSharedTokenQueryParam: useSharedImageToken || place.isShared,
                sharedToken: place.sharedToken,
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: GSSpacing.s,
                      runSpacing: GSSpacing.s,
                      children: [
                        if (place.isShared)
                          const GSInfoChip(
                            icon: Icons.share_outlined,
                            label: 'Partagé',
                            backgroundColor: GSColors.warning100,
                            borderColor: GSColors.warning200,
                            foregroundColor: GSColors.warning700,
                          ),
                        GSInfoChip(
                          icon: Icons.calendar_today_outlined,
                          label: place.date,
                          backgroundColor: GSColors.neutral100,
                          borderColor: GSColors.neutral150,
                        ),
                      ],
                    ),
                    const SizedBox(height: GSSpacing.m),
                    Text(
                      place.title,
                      style: GSTypography.bodyAccentLarge.copyWith(
                        color: GSColors.neutral1000,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (place.fullLocation.isNotEmpty) ...[
                      const SizedBox(height: GSSpacing.s),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: GSColors.neutral500,
                          ),
                          const SizedBox(width: GSSpacing.xs),
                          Expanded(
                            child: Text(
                              place.fullLocation,
                              style: GSTypography.bodyDefaultSmall.copyWith(
                                color: GSColors.neutral650,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (place.description.isNotEmpty) ...[
            const SizedBox(height: GSSpacing.xl),
            Text(
              place.description,
              style: GSTypography.bodyDefaultSmall.copyWith(
                color: GSColors.neutral700,
                height: 1.6,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (place.tags.isNotEmpty) ...[
            const SizedBox(height: GSSpacing.xl),
            Wrap(
              spacing: GSSpacing.s,
              runSpacing: GSSpacing.s,
              children: place.tags.map(_buildTag).toList(),
            ),
          ],
          const SizedBox(height: GSSpacing.xl),
          Row(
            children: [
              GSInfoChip(
                icon: Icons.visibility_outlined,
                label: 'Voir le détail',
                backgroundColor: GSColors.primary50,
                borderColor: GSColors.primary100,
                foregroundColor: GSColors.primary700,
              ),
              const Spacer(),
              _QuickActionButton(
                icon: Icons.directions_outlined,
                onPressed: () =>
                    PlaceActionHandler.openDirections(context, place: place),
              ),
              const SizedBox(width: GSSpacing.s),
              _QuickActionButton(
                icon: Icons.ios_share_outlined,
                onPressed: () =>
                    PlaceActionHandler.share(context, ref, place: place),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return GSInfoChip(
      label: tag,
      backgroundColor: GSColors.primary50,
      borderColor: GSColors.primary100,
      foregroundColor: GSColors.primary700,
    );
  }
}

class _PlaceThumbnail extends StatelessWidget {
  const _PlaceThumbnail({
    this.imageUrl,
    required this.useSharedTokenQueryParam,
    this.sharedToken,
  });

  final String? imageUrl;
  final bool useSharedTokenQueryParam;
  final String? sharedToken;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(GSRadius.l),
      child: Container(
        width: 84,
        height: 96,
        color: GSColors.neutral100,
        child: imageUrl == null
            ? const _ThumbnailPlaceholder()
            : GSProtectedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                useSharedTokenQueryParam: useSharedTokenQueryParam,
                sharedToken: sharedToken,
                placeholder: const _ThumbnailPlaceholder(),
                errorBuilder: (_, _, _) => const _ThumbnailPlaceholder(),
              ),
      ),
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [GSColors.primary100, GSColors.neutral100],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.landscape_outlined,
          color: GSColors.primary700,
          size: 28,
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GSColors.neutral050,
        borderRadius: BorderRadius.circular(GSRadius.full),
        border: Border.all(color: GSColors.neutral150),
      ),
      child: GSIconButton(
        icon: icon,
        onPressed: onPressed,
        size: 20,
        color: GSColors.neutral700,
      ),
    );
  }
}
