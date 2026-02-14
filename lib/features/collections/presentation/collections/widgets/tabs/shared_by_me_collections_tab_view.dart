import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';

import '../../../../../../shared/design_system/design_system.dart';

class SharedByMeCollectionsTabView extends StatelessWidget {
  const SharedByMeCollectionsTabView({
    super.key,
    required this.collections,
    required this.tokensByCollection,
    required this.onCollectionTap,
    required this.onRevokeToken,
  });

  final List<CollectionEntity> collections;
  final Map<String, List<SharedAccessTokenEntity>> tokensByCollection;
  final ValueChanged<CollectionEntity> onCollectionTap;
  final ValueChanged<String> onRevokeToken;

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return Text(
        'Aucun partage actif pour vos collections.',
        style: GSTypography.bodyDefaultMedium.copyWith(
          color: GSColors.neutral600,
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < collections.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == collections.length - 1 ? 0 : GSSpacing.l),
            child: _SharedByMeCollectionCard(
              collection: collections[i],
              tokens: tokensByCollection[collections[i].tag] ?? const [],
              onOpenCollection: () => onCollectionTap(collections[i]),
              onRevokeToken: onRevokeToken,
            ),
          ),
      ],
    );
  }
}

class _SharedByMeCollectionCard extends StatelessWidget {
  const _SharedByMeCollectionCard({
    required this.collection,
    required this.tokens,
    required this.onOpenCollection,
    required this.onRevokeToken,
  });

  final CollectionEntity collection;
  final List<SharedAccessTokenEntity> tokens;
  final VoidCallback onOpenCollection;
  final ValueChanged<String> onRevokeToken;

  @override
  Widget build(BuildContext context) {
    final sharesCount = tokens.length;
    return GSCard(
      padding: const EdgeInsets.all(GSSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: GSColors.primary600.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(GSRadius.m),
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: GSColors.primary600,
                ),
              ),
              const SizedBox(width: GSSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.tag,
                      style: GSTypography.bodyAccentMedium.copyWith(
                        color: GSColors.neutral1000,
                        fontSize: GSFontScale.sf05,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    Wrap(
                      spacing: GSSpacing.s,
                      runSpacing: GSSpacing.s,
                      children: [
                        _MetaPill(
                          icon: Icons.place_outlined,
                          label:
                              '${collection.placesCount} ${collection.placesCount > 1 ? 'lieux' : 'lieu'}',
                        ),
                        _MetaPill(
                          icon: Icons.key_outlined,
                          label:
                              '$sharesCount ${sharesCount > 1 ? 'accès' : 'accès'}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.m),
          Align(
            alignment: Alignment.centerRight,
            child: GSOutlinedButton(
              onPressed: onOpenCollection,
              text: 'Voir la collection',
              icon: Icons.open_in_new,
            ),
          ),
          const SizedBox(height: GSSpacing.m),
          if (tokens.isEmpty)
            Text(
              'Aucun lien de partage actif.',
              style: GSTypography.bodyDefaultSmall.copyWith(
                color: GSColors.neutral600,
              ),
            )
          else
            ...tokens.map(
              (token) => Container(
                margin: const EdgeInsets.only(top: GSSpacing.s),
                padding: const EdgeInsets.all(GSSpacing.m),
                decoration: BoxDecoration(
                  color: GSColors.neutral100.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(GSRadius.m),
                  border: Border.all(color: GSColors.neutral300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: GSSpacing.s,
                            runSpacing: GSSpacing.s,
                            children: [
                              _RightsPill(rightsLabel: token.rights.label),
                              if (token.expiresAt != null)
                                _MetaPill(
                                  icon: Icons.schedule,
                                  label: 'Expire ${_formatDate(token.expiresAt!)}',
                                ),
                            ],
                          ),
                          const SizedBox(height: GSSpacing.s),
                          Text(
                            _maskToken(token.token),
                            style: GSTypography.bodyDefaultSmall.copyWith(
                              color: GSColors.neutral800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: GSSpacing.xs),
                          Text(
                            token.baseUrl,
                            style: GSTypography.captionDefault.copyWith(
                              color: GSColors.neutral600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => onRevokeToken(token.token),
                      child: const Text('Révoquer'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _maskToken(String token) {
    if (token.length <= 10) {
      return token;
    }
    return 'Token: ${token.substring(0, 8)}...${token.substring(token.length - 6)}';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.s,
        vertical: GSSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: GSColors.neutral100,
        borderRadius: BorderRadius.circular(GSRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: GSColors.neutral600),
          const SizedBox(width: GSSpacing.xs),
          Text(
            label,
            style: GSTypography.captionDefault.copyWith(
              color: GSColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RightsPill extends StatelessWidget {
  const _RightsPill({required this.rightsLabel});

  final String rightsLabel;

  @override
  Widget build(BuildContext context) {
    final isWrite = rightsLabel.toLowerCase().contains('écriture');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.s,
        vertical: GSSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isWrite ? GSColors.success100 : GSColors.warning100,
        borderRadius: BorderRadius.circular(GSRadius.full),
      ),
      child: Text(
        rightsLabel,
        style: GSTypography.captionDefault.copyWith(
          color: isWrite ? GSColors.success700 : GSColors.warning700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
