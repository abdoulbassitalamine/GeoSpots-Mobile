import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/tracking/data/services/location_tracking_service.dart';

class EagerInitialization extends ConsumerWidget {
  const EagerInitialization({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    Future.microtask(() async {
      await ref
          .read(locationTrackingServiceProvider)
          .restoreTrackingIfEnabled();
    });

    return child;
  }
}
