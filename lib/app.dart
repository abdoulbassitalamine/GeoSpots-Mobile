import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/app_lifecycle_observer.dart';
import 'package:geo_spots/core/router/app_router.dart';
import 'package:geo_spots/eager_initialization.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GeoSpots extends HookConsumerWidget {
  const GeoSpots({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final navigatorKey = useMemoized(GlobalKey<NavigatorState>.new);

    final lifecycleObserver = useMemoized(() => AppLifecycleObserver(ref));

    useEffect(() {
      WidgetsBinding.instance.addObserver(lifecycleObserver);
      return () => WidgetsBinding.instance.removeObserver(lifecycleObserver);
    }, []);

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Geo Spots',
      key: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: GSAppTheme.lightTheme,
      // Route configuration
      routerConfig: router,

      // Builder
      builder: (context, child) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        return EagerInitialization(
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => ColoredBox(
                  color: GSColors.neutral000,
                  child: SafeArea(child: child ?? const Offstage()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
