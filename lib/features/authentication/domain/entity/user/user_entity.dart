import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/user_dto.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
sealed class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    String? firstName,
    String? lastName,
    String? email,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  factory UserEntity.fromDto(UserDto userDto) => UserEntity(
    id: userDto.id.toString(),
    firstName: userDto.name.split(' ').first,
    lastName: userDto.name.split(' ').last,
    email: userDto.email,
  );
}

extension UserEntityExtension on UserEntity {
  String get fullName => '$firstName $lastName';

  String get username {
    if (email == null) return 'user';
    return email!.split('@').first;
  }
}
