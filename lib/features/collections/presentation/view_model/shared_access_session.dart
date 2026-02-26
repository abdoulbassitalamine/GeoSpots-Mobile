import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_access_session.g.dart';

@riverpod
class ActiveSharedAccessToken extends _$ActiveSharedAccessToken {
  @override
  String? build() => null;

  set token(String? value) => state = value;
}

@riverpod
class ActiveCollectionAccessRight extends _$ActiveCollectionAccessRight {
  @override
  ShareAccessRight? build() => null;

  set right(ShareAccessRight? value) => state = value;
}
