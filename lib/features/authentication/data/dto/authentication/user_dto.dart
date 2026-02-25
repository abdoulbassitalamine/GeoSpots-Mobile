import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  final int id;
  final String name;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
