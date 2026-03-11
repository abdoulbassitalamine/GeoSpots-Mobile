import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../../domain/entity/place_entity.dart';

class PlaceDetailsHeader extends StatelessWidget {
  const PlaceDetailsHeader({
    super.key,
    required this.place,
    required this.onBack,
    this.useSharedImageToken = false,
  });

  final PlaceEntity place;
  final VoidCallback onBack;
  final bool useSharedImageToken;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 360,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      backgroundColor: GSColors.primary700,
      leadingWidth: 72,
      leading: _HeaderLeading(onPressed: onBack),
      actions: const [_HeaderActions()],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _HeaderBackground(
          place: place,
          useSharedImageToken: useSharedImageToken,
        ),
      ),
    );
  }
}

class PlaceDetailsFallbackHeader extends StatelessWidget {
  const PlaceDetailsFallbackHeader({
    super.key,
    required this.onBack,
    this.title = 'Détail du lieu',
    this.subtitle = 'Le contenu du lieu est momentanément indisponible.',
  });

  final VoidCallback onBack;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      backgroundColor: GSColors.primary700,
      leadingWidth: 72,
      leading: _HeaderLeading(onPressed: onBack),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            const _HeaderPlaceholder(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    GSColors.neutral1000.withValues(alpha: 0.10),
                    GSColors.neutral1000.withValues(alpha: 0.26),
                    GSColors.neutral1000.withValues(alpha: 0.82),
                  ],
                ),
              ),
            ),
            Positioned(
              left: GSSpacing.xl,
              right: GSSpacing.xl,
              bottom: GSSpacing.xl3,
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GSTypography.headingMedium.copyWith(
                        color: GSColors.neutral000,
                        fontSize: GSFontScale.sf08,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.s),
                    Text(
                      subtitle,
                      style: GSTypography.bodyDefaultMedium.copyWith(
                        color: GSColors.neutral000.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderLeading extends StatelessWidget {
  const _HeaderLeading({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GSSpacing.l,
        GSSpacing.l,
        0,
        GSSpacing.l,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GSColors.neutral000.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(GSRadius.full),
          border: Border.all(
            color: GSColors.neutral000.withValues(alpha: 0.16),
          ),
        ),
        child: GSBackButton(color: GSColors.neutral000, onPressed: onPressed),
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(GSSpacing.l),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GSColors.neutral000.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(GSRadius.full),
          border: Border.all(
            color: GSColors.neutral000.withValues(alpha: 0.16),
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.more_vert, color: GSColors.neutral000),
          onPressed: () {
            // TODO(dev): Add menu options.
          },
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({
    required this.place,
    required this.useSharedImageToken,
  });

  final PlaceEntity place;
  final bool useSharedImageToken;

  @override
  Widget build(BuildContext context) {
    final visibleTags = place.tags.take(3).toList();

    return Stack(
      fit: StackFit.expand,
      children: [
        if (place.imageUrl != null)
          GSProtectedNetworkImage(
            imageUrl: place.imageUrl!,
            fit: BoxFit.cover,
            useSharedTokenQueryParam: useSharedImageToken || place.isShared,
            sharedToken: place.sharedToken,
            placeholder: const _HeaderPlaceholder(),
            errorBuilder: (_, _, _) => const _HeaderPlaceholder(),
          )
        else
          const _HeaderPlaceholder(),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                GSColors.neutral1000.withValues(alpha: 0.10),
                GSColors.neutral1000.withValues(alpha: 0.26),
                GSColors.neutral1000.withValues(alpha: 0.82),
              ],
            ),
          ),
        ),
        Positioned(
          left: GSSpacing.xl,
          right: GSSpacing.xl,
          bottom: GSSpacing.xl3,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: GSSpacing.s,
                  runSpacing: GSSpacing.s,
                  children: [
                    if (place.isShared)
                      GSInfoChip(
                        icon: Icons.share_outlined,
                        label: 'Lieu partagé',
                        backgroundColor: GSColors.warning100.withValues(
                          alpha: 0.95,
                        ),
                        borderColor: GSColors.warning200,
                        foregroundColor: GSColors.warning700,
                      ),
                    if (place.date.isNotEmpty)
                      GSInfoChip(
                        icon: Icons.calendar_today_outlined,
                        label: place.date,
                        backgroundColor: GSColors.neutral000.withValues(
                          alpha: 0.14,
                        ),
                        borderColor: GSColors.neutral000.withValues(
                          alpha: 0.18,
                        ),
                        foregroundColor: GSColors.neutral000,
                      ),
                  ],
                ),
                const SizedBox(height: GSSpacing.l),
                Text(
                  place.title,
                  style: GSTypography.headingMedium.copyWith(
                    color: GSColors.neutral000,
                    fontSize: GSFontScale.sf09,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (place.fullLocation.isNotEmpty) ...[
                  const SizedBox(height: GSSpacing.m),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: GSColors.neutral000,
                        size: 18,
                      ),
                      const SizedBox(width: GSSpacing.xs),
                      Expanded(
                        child: Text(
                          place.fullLocation,
                          style: GSTypography.bodyDefaultMedium.copyWith(
                            color: GSColors.neutral000.withValues(alpha: 0.84),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (visibleTags.isNotEmpty) ...[
                  const SizedBox(height: GSSpacing.l),
                  Wrap(
                    spacing: GSSpacing.s,
                    runSpacing: GSSpacing.s,
                    children: visibleTags
                        .map(
                          (tag) => GSInfoChip(
                            label: tag,
                            backgroundColor: GSColors.neutral000.withValues(
                              alpha: 0.14,
                            ),
                            borderColor: GSColors.neutral000.withValues(
                              alpha: 0.18,
                            ),
                            foregroundColor: GSColors.neutral000,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderPlaceholder extends StatelessWidget {
  const _HeaderPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [GSColors.primary700, GSColors.primary500],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.landscape_outlined,
          size: 88,
          color: GSColors.neutral000.withValues(alpha: 0.38),
        ),
      ),
    );
  }
}
