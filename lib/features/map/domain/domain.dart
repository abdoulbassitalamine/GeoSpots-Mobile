import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'repository/map_repository.dart';

class MapDomain {
  static Future<void> init() async {}

  static Future<void> invalidate(WidgetRef ref) async {
    ref.invalidate(mapRepositoryProvider);
  }
}
