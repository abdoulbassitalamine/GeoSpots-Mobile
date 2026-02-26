import 'dart:core';

import 'package:geo_spots/core/network/dio_client.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/login_response_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/register_response_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/user_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'authentication_remote_datasource_impl.dart';

part 'authentication_remote_datasource.g.dart';

@Riverpod(keepAlive: true)
IAuthenticationRemoteDatasource authenticationRemoteDatasource(Ref ref) =>
    AuthenticationRemoteDatasourceImpl(
      authenticationClient: ref.watch(dioClientProvider),
    );

abstract interface class IAuthenticationRemoteDatasource {
  Future<Result<LoginResponseDto>> signInWithEmailAndPassword({
    required String mail,
    required String password,
  });

  Future<Result<RegisterResponseDto>> signup({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  });

  Future<Result<void>> logout();

  Future<Result<LoginResponseDto>> refreshToken({required String refreshToken});

  Future<Result<UserDto>> getCurrentUser();

  Future<Result<UserDto>> updateCurrentUser({
    String? firstName,
    String? lastName,
    String? email,
  });

  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
