import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/authentication.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/profile_view_model.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GSCard(
      onTap: () => _showLogoutDialog(context, ref),
      padding: const EdgeInsets.all(GSSpacing.xl),
      border: Border.all(color: GSColors.danger600.withValues(alpha: 0.3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout, color: GSColors.danger600, size: 20),
          const SizedBox(width: GSSpacing.m),
          Text(
            'Déconnexion',
            style: GSTypography.bodyAccentMedium.copyWith(
              color: GSColors.danger600,
              fontSize: GSFontScale.sf04,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(profileViewModelProvider.notifier).logout();
              if(context.mounted) {
               //const SignInRouteData().go(context);
              }
            },
            style: TextButton.styleFrom(foregroundColor: GSColors.danger600),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}
