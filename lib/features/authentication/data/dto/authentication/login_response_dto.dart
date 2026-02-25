import 'package:geo_spots/features/authentication/data/dto/authentication/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponseDto {
  const LoginResponseDto({this.success, this.message, this.data});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  final bool? success;
  final String? message;
  final AuthSessionDto? data;

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthSessionDto {
  const AuthSessionDto({this.token, this.expiredAt, this.data});

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);

  final String? token;
  final DateTime? expiredAt;
  final UserDto? data;

  Map<String, dynamic> toJson() => _$AuthSessionDtoToJson(this);
}
