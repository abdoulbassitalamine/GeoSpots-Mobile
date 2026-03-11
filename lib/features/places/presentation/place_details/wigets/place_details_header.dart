import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../domain/entity/place_entity.dart';

class PlaceDetailsHeader extends StatelessWidget {
  const PlaceDetailsHeader({super.key, required this.place});
  final PlaceEntity place;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: GSColors.primary600,
      leading: const _HeaderLeading(),
      actions: const [_HeaderActions()],
      flexibleSpace: FlexibleSpaceBar(
        background: _HeaderBackground(imageUrl: place.imageUrl),
      ),
    );
  }
}

class _HeaderLeading extends StatelessWidget {
  const _HeaderLeading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(GSSpacing.m),
      child: GSBackButton(
        color: GSColors.neutral000,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(GSSpacing.m),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GSColors.neutral000.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(GSRadius.full),
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
  const _HeaderBackground({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl != null)
          Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const _HeaderPlaceholder(),
          )
        else
          const _HeaderPlaceholder(),
        const _HeaderGradient(),
      ],
    );
  }
}

class _HeaderGradient extends StatelessWidget {
  const _HeaderGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            GSColors.neutral1000.withValues(alpha: 0.7),
          ],
        ),
      ),
    );
  }
}

class _HeaderPlaceholder extends StatelessWidget {
  const _HeaderPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: GSColors.primary600,
      child: Icon(
        Icons.image,
        size: 80,
        color: GSColors.neutral000.withValues(alpha: 0.5),
      ),
    );
  }
}
