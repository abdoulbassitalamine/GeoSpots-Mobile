import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'repository/places_repository.dart';

class PlacesDomain {
  static Future<void> init() async {}

  static Future<void> invalidate(WidgetRef ref) async {
    ref.invalidate(placesRepositoryProvider);
  }
}
