part of 'shared_by_me_collections_tab_view.dart';

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

String _maskSharedToken(String token) {
  if (token.length <= 10) {
    return token;
  }

  return 'Token: ${token.substring(0, 8)}...${token.substring(token.length - 6)}';
}

String _formatSharedTokenDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  return '$day/$month/$year';
}
