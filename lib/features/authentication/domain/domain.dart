import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'entity/authentication_status/authentication_status.dart';
export 'entity/user/user_entity.dart';
export 'navigator/authentication_notifier.dart';
export 'repository/authentication_repository.dart';

class AuthenticationDomain {
  static Future<void> init() async {}

  static Future<void> invalidate(WidgetRef ref) async {
    // Invalidate all repository in domain here
  }
}
