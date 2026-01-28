import 'dart:core';

import 'package:geo_spots/core/network/dio_client.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'authentication_remote_datasource_impl.dart';

final authenticationRemoteDatasourceProvider =
    Provider<IAuthenticationRemoteDatasource>(
      (ref) => AuthenticationRemoteDatasourceImpl(
        authenticationClient: ref.watch(dioClientProvider),
      ),
    );

abstract interface class IAuthenticationRemoteDatasource {
  Future<String> signInWithEmailAndPassword({
    required String mail,
    required String password,
  });

  Future<String?> signup({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  });

  Future<void> logout();

  Future<UserEntity> getCurrentUser();

  Future<String> updateUser(String user);

  Future<String> checkTokenValidity();

  Future<String> sendResetPasswordLink(
    String email,
  );
}
