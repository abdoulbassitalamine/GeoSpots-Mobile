part of 'shared_by_me_collections_tab_view.dart';

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GSInfoChip(
      icon: icon,
      label: label,
      backgroundColor: GSColors.neutral100,
      borderColor: GSColors.neutral150,
      foregroundColor: GSColors.neutral700,
    );
  }
}

class _RightsPill extends StatelessWidget {
  const _RightsPill({required this.rightsLabel});

  final String rightsLabel;

  @override
  Widget build(BuildContext context) {
    final isWrite = rightsLabel.toLowerCase().contains('écriture');

    return GSInfoChip(
      label: rightsLabel,
      backgroundColor: isWrite ? GSColors.success100 : GSColors.warning100,
      borderColor: isWrite ? GSColors.success200 : GSColors.warning200,
      foregroundColor: isWrite ? GSColors.success700 : GSColors.warning700,
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
