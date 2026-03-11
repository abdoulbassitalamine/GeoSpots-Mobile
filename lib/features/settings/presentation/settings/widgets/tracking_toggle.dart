import 'package:flutter/material.dart';
import 'package:geo_spots/features/tracking/domain/entity/location_share_session_entity.dart';

import '../../../../../shared/design_system/design_system.dart';

class TrackingToggle extends StatelessWidget {
  const TrackingToggle({
    super.key,
    required this.isEnabled,
    required this.onChanged,
    required this.isSharing,
    required this.isSharingLoading,
    required this.activeShareSession,
    required this.onStartSharing,
    required this.onStopSharing,
    required this.onShowSession,
  });

  final bool isEnabled;
  final ValueChanged<bool> onChanged;
  final bool isSharing;
  final bool isSharingLoading;
  final LocationShareSessionEntity? activeShareSession;
  final VoidCallback onStartSharing;
  final VoidCallback onStopSharing;
  final VoidCallback onShowSession;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // GPS tracking toggle
        Container(
          padding: const EdgeInsets.all(GSSpacing.xl),
          decoration: BoxDecoration(
            color: GSColors.neutral000,
            borderRadius: BorderRadius.circular(GSRadius.m),
            border: Border.all(
              color: isEnabled ? GSColors.primary600 : GSColors.neutral300,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(GSSpacing.l),
                decoration: BoxDecoration(
                  color: isEnabled
                      ? GSColors.primary600.withValues(alpha: 0.1)
                      : GSColors.neutral100,
                  borderRadius: BorderRadius.circular(GSRadius.m),
                ),
                child: Icon(
                  Icons.location_on,
                  color: isEnabled ? GSColors.primary600 : GSColors.neutral500,
                  size: 24,
                ),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mise à jour de position',
                      style: GSTypography.bodyAccentMedium.copyWith(
                        fontSize: GSFontScale.sf04,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    Text(
                      isEnabled
                          ? 'Position mise à jour en arrière-plan'
                          : 'Activez pour partager votre position',
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: onChanged,
                activeThumbColor: GSColors.primary600,
              ),
            ],
          ),
        ),

        // Sharing card — visible only when tracking is on
        if (isEnabled) ...[
          const SizedBox(height: GSSpacing.m),
          _SharingCard(
            isSharing: isSharing,
            isSharingLoading: isSharingLoading,
            activeShareSession: activeShareSession,
            onStart: onStartSharing,
            onStop: onStopSharing,
            onShowSession: onShowSession,
          ),
        ],
      ],
    );
  }
}

class _SharingCard extends StatelessWidget {
  const _SharingCard({
    required this.isSharing,
    required this.isSharingLoading,
    required this.activeShareSession,
    required this.onStart,
    required this.onStop,
    required this.onShowSession,
  });

  final bool isSharing;
  final bool isSharingLoading;
  final LocationShareSessionEntity? activeShareSession;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onShowSession;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GSSpacing.xl),
      decoration: BoxDecoration(
        color: isSharing
            ? GSColors.primary600.withValues(alpha: 0.05)
            : GSColors.neutral000,
        borderRadius: BorderRadius.circular(GSRadius.m),
        border: Border.all(
          color: isSharing ? GSColors.primary600 : GSColors.neutral300,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(GSSpacing.l),
            decoration: BoxDecoration(
              color: isSharing
                  ? GSColors.primary600.withValues(alpha: 0.12)
                  : GSColors.neutral100,
              borderRadius: BorderRadius.circular(GSRadius.m),
            ),
            child: Icon(
              Icons.share_location,
              color: isSharing ? GSColors.primary600 : GSColors.neutral500,
              size: 24,
            ),
          ),
          const SizedBox(width: GSSpacing.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Partage en direct',
                      style: GSTypography.bodyAccentMedium.copyWith(
                        fontSize: GSFontScale.sf04,
                      ),
                    ),
                    if (isSharing) ...[
                      const SizedBox(width: GSSpacing.s),
                      _LiveBadge(),
                    ],
                  ],
                ),
                const SizedBox(height: GSSpacing.xs),
                Text(
                  isSharing
                      ? 'Votre position est partagée en temps réel'
                      : 'Générez un lien pour partager votre position',
                  style: GSTypography.bodyDefaultSmall.copyWith(
                    color: GSColors.neutral600,
                  ),
                ),
                if (isSharing && activeShareSession?.expiresAt != null) ...[
                  const SizedBox(height: GSSpacing.xs),
                  Text(
                    'Expire le ${_formatDate(activeShareSession!.expiresAt!)}',
                    style: GSTypography.bodyDefaultSmall.copyWith(
                      color: GSColors.neutral500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: GSSpacing.m),
          if (isSharingLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: GSColors.primary600,
              ),
            )
          else if (isSharing)
            _SharingActions(onShow: onShowSession, onStop: onStop)
          else
            GestureDetector(
              onTap: onStart,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GSSpacing.l,
                  vertical: GSSpacing.m,
                ),
                decoration: BoxDecoration(
                  color: GSColors.primary600,
                  borderRadius: BorderRadius.circular(GSRadius.m),
                ),
                child: Text(
                  'Partager',
                  style: GSTypography.bodyAccentSmall.copyWith(
                    color: GSColors.neutral000,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _LiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: GSSpacing.s, vertical: 2),
      decoration: BoxDecoration(
        color: GSColors.success100,
        borderRadius: BorderRadius.circular(GSRadius.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: GSColors.success600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            'LIVE',
            style: GSTypography.bodyAccentSmall.copyWith(
              color: GSColors.success600,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _SharingActions extends StatelessWidget {
  const _SharingActions({required this.onShow, required this.onStop});

  final VoidCallback onShow;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onShow,
          child: Container(
            padding: const EdgeInsets.all(GSSpacing.m),
            decoration: BoxDecoration(
              color: GSColors.primary100,
              borderRadius: BorderRadius.circular(GSRadius.m),
            ),
            child: const Icon(
              Icons.open_in_new,
              size: 18,
              color: GSColors.primary600,
            ),
          ),
        ),
        const SizedBox(width: GSSpacing.s),
        GestureDetector(
          onTap: onStop,
          child: Container(
            padding: const EdgeInsets.all(GSSpacing.m),
            decoration: BoxDecoration(
              color: GSColors.danger100,
              borderRadius: BorderRadius.circular(GSRadius.m),
            ),
            child: const Icon(
              Icons.stop_circle_outlined,
              size: 18,
              color: GSColors.danger600,
            ),
          ),
        ),
      ],
    );
  }
}
