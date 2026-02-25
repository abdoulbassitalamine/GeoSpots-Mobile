import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

@JsonSerializable()
class LoginResponseDto {
  const LoginResponseDto({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.userId,
    this.username,
    this.email,
    this.roles,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? userId;
  final String? username;
  final String? email;
  final Set<String>? roles;

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}
