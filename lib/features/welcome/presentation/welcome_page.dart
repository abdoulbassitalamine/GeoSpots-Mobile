import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/features/welcome/presentation/view/welcome_view.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/route_names.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.delayed(Duration(milliseconds: 1500), () {
        if (context.mounted) {
          context.pushNamed(RouteNames.home);
        }
      });
      return null;
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: GSColorTokens.backgroundPrimary,
        body: const WelcomeView(),
      ),
    );
  }
}
