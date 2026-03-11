import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:geo_spots/features/authentication/presentation/route/route_data.dart';
import 'package:geo_spots/features/settings/domain/domain.dart';
import 'package:geo_spots/features/tracking/presentation/views/location_sharing_bottom_sheet.dart';
import 'package:geo_spots/features/tracking/presentation/views/open_live_location_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/profile_view_model.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';
import '../widgets/settings_section.dart';
import '../widgets/tracking_toggle.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      profileViewModelProvider.select((state) => state.snackbarMessage),
      (previous, next) {
        if (next == null || previous == next) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }
          next.show(context);
          ref.read(profileViewModelProvider.notifier).consumeSnackbar();
        });
      },
    );

    final authStatus = ref.watch(authGuardProvider);
    final isAuthenticated = authStatus is AuthenticationStatusAuthenticated;
    if (!isAuthenticated) {
      return const _GuestProfilePrompt();
    }

    final state = ref.watch(profileViewModelProvider);
    final notifier = ref.read(profileViewModelProvider.notifier);

    return CustomScrollView(
      slivers: [
        const ProfileHeader(),
        if (state.isLoading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: GSCircularLoader()),
          )
        else if (state.user == null)
          SliverFillRemaining(
            hasScrollBody: false,
            child: GSErrorState(
              title: 'Impossible de charger le profil',
              message: state.errorMessage ?? 'Le profil est indisponible.',
              onRetry: () async => SettingsDomain.invalidate(ref),
              retryLabel: 'Réessayer',
            ),
          )
        else
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
                        onChanged: notifier.toggleTracking,
                        isSharing: state.isSharing,
                        isSharingLoading: state.isSharingLoading,
                        activeShareSession: state.activeShareSession,
                        onStartSharing: () async {
                          final session = await notifier.startSharing();
                          if (session != null && context.mounted) {
                            await LocationSharingBottomSheet.show(
                              context,
                              session: session,
                              onStop: notifier.stopSharing,
                            );
                          }
                        },
                        onStopSharing: notifier.stopSharing,
                        onShowSession: () {
                          final session = state.activeShareSession;
                          if (session == null) return;
                          LocationSharingBottomSheet.show(
                            context,
                            session: session,
                            onStop: notifier.stopSharing,
                          );
                        },
                      ),
                      const SizedBox(height: GSSpacing.m),
                      GSOutlinedButton(
                        onPressed: () => OpenLiveLocationDialog.show(context),
                        text: 'Ouvrir un lien reçu',
                        icon: Icons.travel_explore,
                        fullWidth: true,
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

class _GuestProfilePrompt extends StatelessWidget {
  const _GuestProfilePrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GSSpacing.xl),
        child: GSCard(
          padding: const EdgeInsets.all(GSSpacing.xl),
          borderRadius: BorderRadius.circular(GSRadius.l),
          shadows: [GSShadows.s()],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: GSColors.primary100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: GSColors.primary600,
                  size: 34,
                ),
              ),
              const SizedBox(height: GSSpacing.l),
              Text(
                'Connectez-vous pour synchroniser vos lieux',
                textAlign: TextAlign.center,
                style: GSTypography.headingSmall.copyWith(
                  color: GSColors.neutral900,
                ),
              ),
              const SizedBox(height: GSSpacing.s),
              Text(
                'Créez un compte ou connectez-vous pour gérer vos collections personnelles.',
                textAlign: TextAlign.center,
                style: GSTypography.bodyDefaultMedium.copyWith(
                  color: GSColors.neutral600,
                ),
              ),
              const SizedBox(height: GSSpacing.xl),
              GSOutlinedButton(
                onPressed: () => OpenLiveLocationDialog.show(context),
                text: 'Ouvrir un lien de suivi',
                icon: Icons.travel_explore,
                fullWidth: true,
              ),
              const SizedBox(height: GSSpacing.m),
              GSFilledButton(
                onPressed: () => const SignInRouteData().go(context),
                text: 'Se connecter',
                fullWidth: true,
              ),
              const SizedBox(height: GSSpacing.m),
              GSOutlinedButton(
                onPressed: () => const SignUpRouteData().go(context),
                text: 'Créer un compte',
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
