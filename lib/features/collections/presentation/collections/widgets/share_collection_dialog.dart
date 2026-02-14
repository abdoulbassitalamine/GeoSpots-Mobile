import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';
import '../../../../../../shared/design_system/design_system.dart';

class ShareCollectionDialog extends StatelessWidget {
  const ShareCollectionDialog({
    super.key,
    required this.onShare,
  });

  final void Function(ShareAccessRight accessRight) onShare;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Partager la collection', style: GSTypography.headingSmall),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ShareAccessTile(
            right: ShareAccessRight.read,
            icon: Icons.visibility_outlined,
            description: 'Le destinataire peut seulement consulter',
            onTap: () {
              Navigator.of(context).pop();
              onShare(ShareAccessRight.read);
            },
          ),
          const SizedBox(height: GSSpacing.m),
          _ShareAccessTile(
            right: ShareAccessRight.write,
            icon: Icons.edit_outlined,
            description: 'Le destinataire peut consulter et modifier',
            onTap: () {
              Navigator.of(context).pop();
              onShare(ShareAccessRight.write);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}

class _ShareAccessTile extends StatelessWidget {
  const _ShareAccessTile({
    required this.right,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  final ShareAccessRight right;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GSCard(
      onTap: onTap,
      padding: const EdgeInsets.all(GSSpacing.l),
      border: Border.all(color: GSColors.primary600),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(GSSpacing.m),
            decoration: BoxDecoration(
              color: GSColors.primary600.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(GSRadius.s),
            ),
            child: Icon(icon, color: GSColors.primary600),
          ),
          const SizedBox(width: GSSpacing.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  right.label,
                  style: GSTypography.bodyAccentMedium.copyWith(
                    color: GSColors.neutral1000,
                  ),
                ),
                const SizedBox(height: GSSpacing.xs),
                Text(
                  description,
                  style: GSTypography.bodyDefaultSmall.copyWith(
                    color: GSColors.neutral600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
