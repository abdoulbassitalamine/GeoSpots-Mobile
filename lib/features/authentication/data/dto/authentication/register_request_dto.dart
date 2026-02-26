import 'package:json_annotation/json_annotation.dart';

part 'register_request_dto.g.dart';

@JsonSerializable()
class RegisterRequestDto {
  const RegisterRequestDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestDtoFromJson(json);

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  @JsonKey(name: 'confirmPassword')
  final String passwordConfirmation;

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}
