import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/presentation/route/route_data.dart';
import 'package:geo_spots/gen/assets.gen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/utils/extensions/sized_box_extension.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../widgets/sign_in_form.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GSIcons.icons.logoGeoSpotsVerticale.svg(),
          Text(
            'Vos lieux, partout',
            style: context.bodyDefaultSmall.copyWith(
              fontSize: GSFontScale.sf04,
            ),
          ),
          GSSpacing.$600.toInt().toHeight,
          LoginForm(),
          GSSpacing.$800.toInt().toHeight,
          GSTextBetweenDivider(
            text: 'OU',
            lineColor: GSColorTokens.borderPrimary,
          ),
          GSSpacing.$800.toInt().toHeight,
          GSContainerButton.outline(
            padding: const EdgeInsets.symmetric(vertical: GSSpacing.$250),
            onPressed: () => const SignUpRouteData().go(context),
            text: 'Créer un compte',
          ),
        ],
      ),
    );
  }
}
