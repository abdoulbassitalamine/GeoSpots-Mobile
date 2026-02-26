part of 'collections_api_dto.dart';

@JsonSerializable()
class AccessTokenDto {
  const AccessTokenDto({
    this.id,
    this.token,
    this.resourceType,
    this.resourceId,
    this.permission,
    this.expiresAt,
    this.revokedAt,
    this.createdAt,
    this.label,
    this.accessCount,
    this.isValid,
    this.resourceName,
  });

  factory AccessTokenDto.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenDtoFromJson(json);

  final int? id;
  final String? token;
  final String? resourceType;
  final int? resourceId;
  final String? permission;
  final DateTime? expiresAt;
  final DateTime? revokedAt;
  final DateTime? createdAt;
  final String? label;
  final int? accessCount;
  final bool? isValid;
  final String? resourceName;

  Map<String, dynamic> toJson() => _$AccessTokenDtoToJson(this);
}
