import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_spots/features/tracking/domain/entity/location_share_session_entity.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../shared/design_system/design_system.dart';

class LocationSharingBottomSheet extends StatelessWidget {
  const LocationSharingBottomSheet({
    super.key,
    required this.session,
    required this.onStop,
  });

  final LocationShareSessionEntity session;
  final VoidCallback onStop;

  static Future<void> show(
    BuildContext context, {
    required LocationShareSessionEntity session,
    required VoidCallback onStop,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationSharingBottomSheet(
        session: session,
        onStop: onStop,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GSColors.neutral000,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        GSSpacing.xl,
        GSSpacing.xl,
        GSSpacing.xl,
        GSSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: GSColors.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: GSSpacing.xl),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(GSSpacing.l),
                decoration: BoxDecoration(
                  color: GSColors.primary600.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(GSRadius.m),
                ),
                child: const Icon(
                  Icons.share_location,
                  color: GSColors.primary600,
                  size: 24,
                ),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Partage actif',
                      style: GSTypography.headingSmall.copyWith(
                        color: GSColors.neutral900,
                      ),
                    ),
                    if (session.expiresAt != null) ...[
                      const SizedBox(height: GSSpacing.xs),
                      Text(
                        'Expire le ${_formatDate(session.expiresAt!)}',
                        style: GSTypography.bodyDefaultSmall.copyWith(
                          color: GSColors.neutral600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Live indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GSSpacing.m,
                  vertical: GSSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: GSColors.success100,
                  borderRadius: BorderRadius.circular(GSRadius.s),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: GSColors.success600,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: GSSpacing.xs),
                    Text(
                      'LIVE',
                      style: GSTypography.bodyAccentSmall.copyWith(
                        color: GSColors.success600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.xl),

          // URL card
          Text(
            'Lien de suivi',
            style: GSTypography.bodyAccentMedium.copyWith(
              color: GSColors.neutral700,
            ),
          ),
          const SizedBox(height: GSSpacing.m),
          GestureDetector(
            onTap: () => _copyToClipboard(context, session.url),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(GSSpacing.l),
              decoration: BoxDecoration(
                color: GSColors.neutral100,
                borderRadius: BorderRadius.circular(GSRadius.m),
                border: Border.all(color: GSColors.neutral300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      session.url,
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral700,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: GSSpacing.m),
                  const Icon(
                    Icons.copy,
                    size: 18,
                    color: GSColors.primary600,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: GSSpacing.s),
          Text(
            'Appuyez pour copier le lien',
            style: GSTypography.bodyDefaultSmall.copyWith(
              color: GSColors.neutral500,
            ),
          ),
          const SizedBox(height: GSSpacing.xl),

          // Token card
          Text(
            'Token de partage',
            style: GSTypography.bodyAccentMedium.copyWith(
              color: GSColors.neutral700,
            ),
          ),
          const SizedBox(height: GSSpacing.m),
          GestureDetector(
            onTap: () => _copyToClipboard(context, session.token),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(GSSpacing.l),
              decoration: BoxDecoration(
                color: GSColors.neutral100,
                borderRadius: BorderRadius.circular(GSRadius.m),
                border: Border.all(color: GSColors.neutral300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      session.token,
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral700,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: GSSpacing.m),
                  const Icon(
                    Icons.copy,
                    size: 18,
                    color: GSColors.primary600,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: GSSpacing.xl),

          // Actions
          Row(
            children: [
              Expanded(
                child: GSOutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onStop();
                  },
                  text: 'Arrêter',
                ),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: GSFilledButton(
                  onPressed: () => _shareViaOS(context),
                  text: 'Partager',
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.l),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copié dans le presse-papiers'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _shareViaOS(BuildContext context) async {
    final shareText = StringBuffer()
      ..writeln('Suivez ma position en temps réel :')
      ..writeln(session.url);
    if (session.expiresAt != null) {
      shareText.writeln('Expire le ${_formatDate(session.expiresAt!)}');
    }
    await SharePlus.instance.share(
      ShareParams(
        subject: 'Ma position en temps réel',
        text: shareText.toString(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} à ${date.hour.toString().padLeft(2, '0')}h'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
