import 'package:flutter/material.dart';
import '../../../../../../shared/design_system/design_system.dart';

class CollectionsHeader extends StatelessWidget {

  const CollectionsHeader({
    super.key,
    required this.title,
    this.onImportPressed,
    required this.onAddSharedAccessPressed,
  });
  final String title;
  final VoidCallback? onImportPressed;
  final VoidCallback onAddSharedAccessPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: GSColorTokens.primaryGradientVertical,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            GSSpacing.xl,
            GSSpacing.xl,
            GSSpacing.xl,
            GSSpacing.xl3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GSTypography.headingMedium.copyWith(
                        color: GSColors.neutral000,
                        fontSize: GSFontScale.sf07,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (onImportPressed != null) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: GSColors.neutral000.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(GSRadius.m),
                      ),
                      child: IconButton(
                        onPressed: onImportPressed,
                        icon: const Icon(
                          Icons.upload_file,
                          color: GSColors.neutral000,
                        ),
                        iconSize: 28,
                        tooltip: 'Importer une collection',
                      ),
                    ),
                    const SizedBox(width: GSSpacing.s),
                  ],
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: GSColors.neutral000.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(GSRadius.m),
                    ),
                    child: IconButton(
                      onPressed: onAddSharedAccessPressed,
                      icon: const Icon(
                        Icons.key_outlined,
                        color: GSColors.neutral000,
                      ),
                      iconSize: 28,
                      tooltip: 'Ajouter un accès partagé',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
