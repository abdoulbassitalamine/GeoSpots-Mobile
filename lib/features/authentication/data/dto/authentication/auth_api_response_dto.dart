import 'package:json_annotation/json_annotation.dart';

import 'login_response_dto.dart';
import 'register_response_dto.dart';
import 'user_dto.dart';

part 'auth_api_response_dto.g.dart';

@JsonSerializable()
class ApiResponseUserDto {
  const ApiResponseUserDto({this.message, this.data});

  factory ApiResponseUserDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseUserDtoFromJson(json);

  final String? message;
  final UserDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseUserDtoToJson(this);
}

@JsonSerializable()
class ApiResponseLoginDto {
  const ApiResponseLoginDto({this.message, this.data});

  factory ApiResponseLoginDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseLoginDtoFromJson(json);

  final String? message;
  final LoginResponseDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseLoginDtoToJson(this);
}

@JsonSerializable()
class ApiResponseRegisterDto {
  const ApiResponseRegisterDto({this.message, this.data});

  factory ApiResponseRegisterDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseRegisterDtoFromJson(json);

  final String? message;
  final RegisterResponseDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseRegisterDtoToJson(this);
}
