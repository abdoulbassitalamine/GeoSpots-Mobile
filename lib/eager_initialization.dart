import 'package:flutter/widgets.dart';
import 'package:geo_spots/core/services/deep_link_service.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/authentication_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/tracking/data/services/location_tracking_service.dart';

class EagerInitialization extends ConsumerStatefulWidget {
  const EagerInitialization({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<EagerInitialization> createState() =>
      _EagerInitializationState();
}

class _EagerInitializationState extends ConsumerState<EagerInitialization> {
  @override
  void initState() {
    super.initState();
    ref.read(deepLinkServiceProvider);
    Future<void>.microtask(() async {
      await ref.read(authenticationViewModelProvider.notifier).autoSignIn();
      if (!mounted) {
        return;
      }
      await ref
          .read(locationTrackingServiceProvider)
          .restoreTrackingIfEnabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
