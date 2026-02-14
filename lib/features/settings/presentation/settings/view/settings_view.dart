import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/profile_view_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';
import '../widgets/settings_section.dart';
import '../widgets/tracking_toggle.dart';
import '../widgets/logout_button.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);

    if (state.isLoading) {
      return const Center(child: GSCircularLoader());
    }

    if (state.user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: GSColors.danger600,
            ),
            const SizedBox(height: GSSpacing.xl),
            Text(
              state.errorMessage ?? 'Erreur de chargement du profil',
              style: GSTypography.bodyDefaultMedium.copyWith(
                color: GSColors.danger600,
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        ProfileHeader(user: state.user!),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(GSSpacing.xl),
            child: Column(
              children: [
                ProfileStats(
                  user: state.user!,
                  totalPlaces: state.totalPlaces,
                  totalCollections: state.totalCollections,
                  sharedPlaces: state.sharedPlaces,
                ),
                const SizedBox(height: GSSpacing.xl),
                SettingsSection(
                  title: 'Paramètres',
                  children: [
                    TrackingToggle(
                      isEnabled: state.isTrackingEnabled,
                      onChanged: (value) {
                        ref
                            .read(profileViewModelProvider.notifier)
                            .toggleTracking(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: GSSpacing.xl3),
                const LogoutButton(),
                const SizedBox(height: GSSpacing.xl3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
