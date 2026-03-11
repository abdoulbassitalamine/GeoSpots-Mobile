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
          GSSpacing.$500.toInt().toHeight,
          SignupForm(),
          GSSpacing.$150.toInt().toHeight,
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
          GSSpacing.$100.toInt().toHeight,
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => const MapRouteData().go(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: GSSpacing.$100),
                child: Text(
                  'Continuer en invité',
                  style: context.captionDefault.copyWith(
                    color: GSColors.neutral600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
