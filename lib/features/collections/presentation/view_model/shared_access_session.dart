import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final activeSharedAccessTokenProvider =
    NotifierProvider<ActiveSharedAccessTokenNotifier, String?>(
      ActiveSharedAccessTokenNotifier.new,
    );

class ActiveSharedAccessTokenNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  set token(String? value) => state = value;
}

final activeCollectionAccessRightProvider =
    NotifierProvider<ActiveCollectionAccessRightNotifier, ShareAccessRight?>(
      ActiveCollectionAccessRightNotifier.new,
    );

class ActiveCollectionAccessRightNotifier extends Notifier<ShareAccessRight?> {
  @override
  ShareAccessRight? build() => null;

  set right(ShareAccessRight? value) => state = value;
}
