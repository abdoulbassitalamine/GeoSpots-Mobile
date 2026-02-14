import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';

final activeSharedAccessTokenProvider =
    NotifierProvider<ActiveSharedAccessTokenNotifier, String?>(
      ActiveSharedAccessTokenNotifier.new,
    );

class ActiveSharedAccessTokenNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setToken(String? token) {
    state = token;
  }
}

final activeCollectionAccessRightProvider =
    NotifierProvider<ActiveCollectionAccessRightNotifier, ShareAccessRight?>(
      ActiveCollectionAccessRightNotifier.new,
    );

class ActiveCollectionAccessRightNotifier extends Notifier<ShareAccessRight?> {
  @override
  ShareAccessRight? build() => null;

  void setRight(ShareAccessRight? right) {
    state = right;
  }
}
