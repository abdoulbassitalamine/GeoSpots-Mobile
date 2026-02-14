import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:geo_spots/features/home/presentation/route/route_data.dart';
import 'package:geo_spots/features/map/presentation/route/route_data.dart';
import 'package:geo_spots/features/welcome/presentation/view/welcome_view.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final timer = Timer(const Duration(milliseconds: 1500), () {
        if (context.mounted) {
          const HomeRouteData().go(context);
          return;
        }
      });

      return timer.cancel;
    }, const []);

    return SafeArea(
      child: Scaffold(
        backgroundColor: GSColorTokens.backgroundPrimary,
        body: const WelcomeView(),
      ),
    );
  }
}
