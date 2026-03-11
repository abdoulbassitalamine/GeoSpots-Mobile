import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/tracking/data/services/location_tracking_service.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver(this.ref);

  final WidgetRef ref;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await ref
            .read(locationTrackingServiceProvider)
            .restoreTrackingIfEnabled();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
