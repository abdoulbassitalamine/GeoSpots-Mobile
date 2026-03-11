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

    return GSPremiumPanel(
      padding: const EdgeInsets.all(GSSpacing.xl),
      borderColor: GSColors.neutral150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [GSColors.info100, GSColors.primary100],
                  ),
                  borderRadius: BorderRadius.circular(GSRadius.l),
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: GSColors.primary700,
                ),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GSInfoChip(
                      icon: Icons.key_outlined,
                      label: 'Partages actifs',
                      backgroundColor: GSColors.neutral100,
                      borderColor: GSColors.neutral150,
                    ),
                    const SizedBox(height: GSSpacing.m),
                    Text(
                      collection.tag,
                      style: GSTypography.bodyAccentLarge.copyWith(
                        color: GSColors.neutral1000,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.s),
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
          const SizedBox(height: GSSpacing.xl),
          Align(
            alignment: Alignment.centerRight,
            child: GSOutlinedButton(
              onPressed: onOpenCollection,
              text: 'Voir la collection',
              icon: Icons.open_in_new,
            ),
          ),
          const SizedBox(height: GSSpacing.xl),
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
                margin: const EdgeInsets.only(top: GSSpacing.m),
                padding: const EdgeInsets.all(GSSpacing.l),
                decoration: BoxDecoration(
                  color: GSColors.neutral050,
                  borderRadius: BorderRadius.circular(GSRadius.l),
                  border: Border.all(color: GSColors.neutral150),
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
                            const SizedBox(height: GSSpacing.m),
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
                      Padding(
                        padding: const EdgeInsets.only(left: GSSpacing.m),
                        child: GSOutlinedButton(
                          onPressed: () => onRevokeTokenById(token.id),
                          text: 'Révoquer',
                          textColor: GSColors.danger600,
                          borderColor: GSColors.danger200,
                          padding: const EdgeInsets.symmetric(
                            horizontal: GSSpacing.l,
                            vertical: GSSpacing.m,
                          ),
                        ),
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
