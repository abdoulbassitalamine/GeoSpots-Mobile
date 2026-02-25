import 'package:json_annotation/json_annotation.dart';

part 'register_response_dto.g.dart';

@JsonSerializable()
class RegisterResponseDto {
  const RegisterResponseDto({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.userId,
    this.username,
    this.email,
    this.roles,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);

  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? userId;
  final String? username;
  final String? email;
  final Set<String>? roles;

  Map<String, dynamic> toJson() => _$RegisterResponseDtoToJson(this);
}
