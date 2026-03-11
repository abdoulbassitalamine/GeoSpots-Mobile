import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/presentation/route/route_data.dart';
import 'package:geo_spots/features/map/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/utils/extensions/sized_box_extension.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../widget/signup_form.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GSSpacing.$200.toInt().toHeight,
          Text(
            'Bienvenue',
            style: context.headingMedium.copyWith(
              fontSize: GSFontScale.sf08,
              fontWeight: FontWeight.bold,
              fontFamily: GSFontFamily.display,
            ),
          ),
          GSSpacing.$200.toInt().toHeight,
          Text(
            'Rejoignez la communauté GeoSpots en 2 étapes simples.',
            style: context.bodyDefaultSmall.copyWith(
              fontSize: GSFontScale.sf04,
              color: GSColorTokens.textSecondary,
            ),
          ),
          GSSpacing.$300.toInt().toHeight,
          SignupForm(),
          GSSpacing.$200.toInt().toHeight,
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                text: 'Vous avez déjà un compte ? ',
                style: context.bodyDefaultSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: GSColors.neutral950,
                ),
                children: [
                  TextSpan(
                    text: 'Se connecter',
                    style: context.bodyDefaultSmall.copyWith(
                      color: GSColors.neutral950,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => const SignInRouteData().go(context),
                  ),
                ],
              ),
            ),
          ),
          GSSpacing.$150.toInt().toHeight,
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => const MapRouteData().go(context),
              child: Text(
                'Continuer en invité',
                style: context.bodyAccentSmall.copyWith(
                  color: GSColors.neutral900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
