import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  const UserDto({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.active,
    this.roles,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final DateTime? createdAt;
  final bool? active;
  final Set<String>? roles;

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
