part of 'shared_by_me_collections_tab_view.dart';

class _SharedByMeCollectionCard extends StatelessWidget {
  const _SharedByMeCollectionCard({
    required this.collection,
    required this.tokens,
    required this.onOpenCollection,
    required this.onRevokeTokenById,
  });

  final CollectionEntity collection;
  final List<SharedAccessTokenEntity> tokens;
  final VoidCallback onOpenCollection;
  final ValueChanged<String> onRevokeTokenById;

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
                          label: '$sharesCount accès',
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
            ...tokens.map((token) {
              final isTokenValid = token.isValid;
              final canRevoke = isTokenValid && token.id.trim().isNotEmpty;

              return Container(
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
                                  label:
                                      'Expire ${_formatSharedTokenDate(token.expiresAt!)}',
                                ),
                              if (!isTokenValid)
                                const _MetaPill(
                                  icon: Icons.block_outlined,
                                  label: 'Token révoqué',
                                ),
                            ],
                          ),
                          const SizedBox(height: GSSpacing.s),
                          Text(
                            _maskSharedToken(token.token),
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
                          if (!isTokenValid) ...[
                            const SizedBox(height: GSSpacing.s),
                            Text(
                              'Ce token n\'est plus valide ou a été révoqué.',
                              style: GSTypography.captionDefault.copyWith(
                                color: GSColors.danger600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (canRevoke)
                      TextButton(
                        onPressed: () => onRevokeTokenById(token.id),
                        child: const Text('Révoquer'),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
