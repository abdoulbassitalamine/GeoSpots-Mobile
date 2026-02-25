import 'package:geo_spots/features/authentication/data/dto/authentication/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_response_dto.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class RegisterResponseDto {
  const RegisterResponseDto({
    this.user,
    this.token,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);

  final UserDto? user;
  final String? token;

  Map<String, dynamic> toJson() => _$RegisterResponseDtoToJson(this);
}
