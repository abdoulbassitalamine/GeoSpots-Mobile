import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginRequestDto {
  const LoginRequestDto({
    required this.email,
    required this.password,
  });

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}
