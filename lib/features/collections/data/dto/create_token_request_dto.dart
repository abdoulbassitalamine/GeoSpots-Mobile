part of 'collections_api_dto.dart';

@JsonSerializable()
class CreateTokenRequestDto {
  const CreateTokenRequestDto({
    required this.resourceType,
    required this.resourceId,
    required this.permission,
    this.expiresAt,
    this.label,
  });

  factory CreateTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTokenRequestDtoFromJson(json);

  final String resourceType;
  final int resourceId;
  final String permission;
  final DateTime? expiresAt;
  final String? label;

  Map<String, dynamic> toJson() => _$CreateTokenRequestDtoToJson(this);
}
