part of 'collections_api_dto.dart';

@JsonSerializable()
class CollectionShareTokenRequestDto {
  const CollectionShareTokenRequestDto({
    required this.permission,
    this.expiresAt,
    this.label,
  });

  factory CollectionShareTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionShareTokenRequestDtoFromJson(json);

  final String permission;
  final DateTime? expiresAt;
  final String? label;

  Map<String, dynamic> toJson() => _$CollectionShareTokenRequestDtoToJson(this);
}
