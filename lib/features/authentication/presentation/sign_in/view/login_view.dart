import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/presentation/route/route_data.dart';
import 'package:geo_spots/features/map/presentation/route/route_data.dart';
import 'package:geo_spots/gen/assets.gen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../widgets/sign_in_form.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GSIcons.icons.logoGeoSpotsVerticale.svg(height: 100),
        const SizedBox(height: 4),
        Text(
          'Vos lieux, partout',
          style: context.bodyDefaultSmall.copyWith(
            fontSize: GSFontScale.sf04,
          ),
        ),
        const SizedBox(height: 20),
        LoginForm(),
        const SizedBox(height: 25),
        GSTextBetweenDivider(
          text: 'OU',
          lineColor: GSColorTokens.borderPrimary,
        ),
        const SizedBox(height: 25),
        GSContainerButton.outline(
          padding: const EdgeInsets.symmetric(vertical: GSSpacing.$200),
          onPressed: () => const SignUpRouteData().go(context),
          text: 'Créer un compte',
        ),
        TextButton(
          onPressed: () => const MapRouteData().go(context),
          child: Text(
            'Continuer en invité',
            style: context.bodyAccentSmall.copyWith(
              color: GSColors.neutral900,
            ),
          ),
        ),
      ],
    );
  }
}
