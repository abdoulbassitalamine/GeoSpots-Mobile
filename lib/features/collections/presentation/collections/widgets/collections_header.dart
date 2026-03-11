import 'package:flutter/material.dart';
import '../../../../../../shared/design_system/design_system.dart';

class CollectionsHeader extends StatelessWidget {
  const CollectionsHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statLabel,
    this.onImportPressed,
    required this.onAddSharedAccessPressed,
  });
  final String title;
  final String subtitle;
  final String statLabel;
  final VoidCallback? onImportPressed;
  final VoidCallback onAddSharedAccessPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: GSColorTokens.primaryGradientVertical,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -44,
            right: -12,
            child: _GlowOrb(
              size: 132,
              color: GSColors.neutral000.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: -58,
            left: -16,
            child: _GlowOrb(
              size: 148,
              color: GSColors.primary300.withValues(alpha: 0.18),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                GSSpacing.xl,
                GSSpacing.xl,
                GSSpacing.xl,
                GSSpacing.xl3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Collections',
                              style: GSTypography.labelAccent.copyWith(
                                color: GSColors.neutral000.withValues(
                                  alpha: 0.88,
                                ),
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: GSSpacing.s),
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
                                color: GSColors.neutral000.withValues(
                                  alpha: 0.82,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: GSSpacing.l),
                      Column(
                        children: [
                          if (onImportPressed != null)
                            _HeaderActionButton(
                              icon: Icons.upload_file_outlined,
                              tooltip: 'Importer une collection',
                              onPressed: onImportPressed!,
                            ),
                          const SizedBox(height: GSSpacing.s),
                          _HeaderActionButton(
                            icon: Icons.key_outlined,
                            tooltip: 'Ajouter un accès partagé',
                            onPressed: onAddSharedAccessPressed,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: GSSpacing.xl),
                  GSInfoChip(
                    icon: Icons.grid_view_rounded,
                    label: statLabel,
                    backgroundColor: GSColors.neutral000.withValues(
                      alpha: 0.14,
                    ),
                    borderColor: GSColors.neutral000.withValues(alpha: 0.20),
                    foregroundColor: GSColors.neutral000,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GSColors.neutral000.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(GSRadius.l),
        border: Border.all(color: GSColors.neutral000.withValues(alpha: 0.16)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: GSColors.neutral000),
        iconSize: 24,
        tooltip: tooltip,
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
