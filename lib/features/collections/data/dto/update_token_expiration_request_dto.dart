part of 'collections_api_dto.dart';

@JsonSerializable()
class UpdateTokenExpirationRequestDto {
  const UpdateTokenExpirationRequestDto({required this.expiresAt});

  factory UpdateTokenExpirationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTokenExpirationRequestDtoFromJson(json);

  final DateTime expiresAt;

  Map<String, dynamic> toJson() =>
      _$UpdateTokenExpirationRequestDtoToJson(this);
}
