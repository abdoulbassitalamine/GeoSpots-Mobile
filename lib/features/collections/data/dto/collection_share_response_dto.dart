part of 'collections_api_dto.dart';

@JsonSerializable()
class CollectionShareResponseDto {
  const CollectionShareResponseDto({
    this.token,
    this.url,
    this.permission,
    this.resourceType,
    this.resourceId,
    this.expiresAt,
  });

  factory CollectionShareResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionShareResponseDtoFromJson(json);

  final String? token;
  final String? url;
  final String? permission;
  final String? resourceType;
  final int? resourceId;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => _$CollectionShareResponseDtoToJson(this);
}
