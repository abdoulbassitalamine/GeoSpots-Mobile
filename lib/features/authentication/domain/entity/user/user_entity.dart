import 'package:freezed_annotation/freezed_annotation.dart';

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


}

extension UserEntityExtension on UserEntity {
  String get fullName => '$firstName $lastName';
}
