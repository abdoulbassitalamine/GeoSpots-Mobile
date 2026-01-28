import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/presentation/sign_in/view/login_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/design_system/theme/spacing.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: GSSpacing.$250,
            vertical: GSSpacing.$300,
          ),
          child: const LoginView(),
        ),
      ),
    );
  }
}
