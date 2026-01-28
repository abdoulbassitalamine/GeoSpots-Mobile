import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/presentation/sign_up/view/sign_up_view.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Créer un compte',
            style: context.headingMedium.copyWith(
              fontSize: GSFontScale.sf06,
              color: GSColors.neutral950,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          backgroundColor: GSColorTokens.backgroundSecondary,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: GSSpacing.$250,
            vertical: GSSpacing.$100,
          ),
          child: const SignUpView(),
        ),
        backgroundColor: GSColorTokens.backgroundPrimary,
      ),
    );
  }
}
