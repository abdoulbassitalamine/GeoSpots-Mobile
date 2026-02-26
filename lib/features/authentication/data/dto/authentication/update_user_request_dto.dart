import 'package:json_annotation/json_annotation.dart';

part 'update_user_request_dto.g.dart';

@JsonSerializable()
class UpdateUserRequestDto {
  const UpdateUserRequestDto({this.firstName, this.lastName, this.email});

  factory UpdateUserRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestDtoFromJson(json);

  final String? firstName;
  final String? lastName;
  final String? email;

  Map<String, dynamic> toJson() => _$UpdateUserRequestDtoToJson(this);
}
