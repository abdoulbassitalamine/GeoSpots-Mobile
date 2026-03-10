part of 'shared_with_me_collections_tab_view.dart';

Future<void> _confirmRemoveAccess(
  BuildContext context, {
  required String collectionName,
  required String token,
  required ValueChanged<String> onRemoveAccess,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GSRadius.l),
        ),
        titlePadding: const EdgeInsets.fromLTRB(
          GSSpacing.xl,
          GSSpacing.xl,
          GSSpacing.xl,
          0,
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          GSSpacing.xl,
          GSSpacing.m,
          GSSpacing.xl,
          GSSpacing.xl,
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: GSColors.danger100,
                borderRadius: BorderRadius.circular(GSRadius.full),
              ),
              child: const Icon(
                Icons.remove_circle_outline,
                color: GSColors.danger600,
                size: 20,
              ),
            ),
            const SizedBox(width: GSSpacing.s),
            Expanded(
              child: Text(
                'Retirer cet accès ?',
                style: GSTypography.headingSmall.copyWith(
                  color: GSColors.neutral1000,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Collection: $collectionName',
              style: GSTypography.bodyAccentMedium.copyWith(
                color: GSColors.neutral900,
              ),
            ),
            const SizedBox(height: GSSpacing.s),
            Text(
              'Vous ne verrez plus cette collection dans "Partagées avec moi".',
              style: GSTypography.bodyDefaultSmall.copyWith(
                color: GSColors.neutral700,
              ),
            ),
            const SizedBox(height: GSSpacing.m),
            Container(
              padding: const EdgeInsets.all(GSSpacing.m),
              decoration: BoxDecoration(
                color: GSColors.warning100,
                borderRadius: BorderRadius.circular(GSRadius.m),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: GSColors.warning700,
                  ),
                  const SizedBox(width: GSSpacing.s),
                  Expanded(
                    child: Text(
                      'Cette action retire uniquement ton accès local.',
                      style: GSTypography.captionDefault.copyWith(
                        color: GSColors.warning700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: GSSpacing.l),
            Row(
              children: [
                Expanded(
                  child: GSOutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    text: 'Annuler',
                  ),
                ),
                const SizedBox(width: GSSpacing.s),
                Expanded(
                  child: GSFilledButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    text: 'Retirer',
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [SizedBox.shrink()],
        actionsPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: GSSpacing.xl,
          vertical: GSSpacing.l,
        ),
      );
    },
  );

  if (confirmed ?? false) {
    onRemoveAccess(token);
  }
}
