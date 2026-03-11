import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'repository/collections_repository.dart';

class CollectionsDomain {
  static Future<void> init() async {}

  static Future<void> invalidate(WidgetRef ref) async {
    ref.invalidate(collectionsRepositoryProvider);
  }
}
