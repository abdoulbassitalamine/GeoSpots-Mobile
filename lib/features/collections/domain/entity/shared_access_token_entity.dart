import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/share_access_right.dart';

part 'shared_access_token_entity.freezed.dart';
part 'shared_access_token_entity.g.dart';

@freezed
sealed class SharedAccessTokenEntity with _$SharedAccessTokenEntity {
  const factory SharedAccessTokenEntity({
    @Default('') String token,
    @Default('') String baseUrl,
    @JsonKey(fromJson: _rightsFromJson, toJson: _rightsToJson)
    @Default(ShareAccessRight.read)
    ShareAccessRight rights,
    @Default('collection') String resourceType,
    @Default('') String resourceId,
    DateTime? expiresAt,
  }) = _SharedAccessTokenEntity;

  factory SharedAccessTokenEntity.fromJson(Map<String, dynamic> json) =>
      _$SharedAccessTokenEntityFromJson(json);
}

ShareAccessRight _rightsFromJson(String? raw) {
  final value = raw ?? ShareAccessRight.read.value;
  return ShareAccessRight.values.firstWhere(
    (element) => element.value == value,
    orElse: () => ShareAccessRight.read,
  );
}

String _rightsToJson(ShareAccessRight rights) => rights.value;
