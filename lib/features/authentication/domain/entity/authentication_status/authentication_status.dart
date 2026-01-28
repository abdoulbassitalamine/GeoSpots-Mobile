import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';

part 'authentication_status.freezed.dart';

@Freezed(fromJson: false)
sealed class AuthenticationStatus with _$AuthenticationStatus {
  const factory AuthenticationStatus.unknown() = AuthenticationStatusUnknown;

  const factory AuthenticationStatus.authenticated({required UserEntity user}) =
      AuthenticationStatusAuthenticated;

  const factory AuthenticationStatus.unauthenticated(bool hasError) =
      AuthenticationStatusUnauthenticated;
}
