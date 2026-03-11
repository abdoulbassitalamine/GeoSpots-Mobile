import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'repository/tracking_repository.dart';

class TrackingDomain {
  static Future<void> init() async {}

  static Future<void> invalidate(WidgetRef ref) async {
    ref.invalidate(trackingRepositoryProvider);
  }
}
