import 'package:geo_spots/features/authentication/authentication.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'repository/settings_repository.dart';

class SettingsDomain {
  static Future<void> init() async {}

  static Future<void> invalidate(WidgetRef ref) async {
    ref.invalidate(settingsRepositoryProvider);
    await AuthenticationDomain.invalidate(ref);
  
  
  }
}
