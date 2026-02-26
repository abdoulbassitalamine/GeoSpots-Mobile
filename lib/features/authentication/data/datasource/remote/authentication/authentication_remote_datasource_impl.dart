import 'package:dio/dio.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/exception/dio_exception.dart';
import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/datasource/remote/authentication/authentication_remote_datasource.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/auth_api_response_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/change_password_request_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/login_request_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/login_response_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/refresh_token_request_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/register_request_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/register_response_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/update_user_request_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/user_dto.dart';

class AuthenticationRemoteDatasourceImpl
    implements IAuthenticationRemoteDatasource {
  AuthenticationRemoteDatasourceImpl({required Dio authenticationClient})
    : _authenticationClient = authenticationClient;

  final Dio _authenticationClient;

  @override
  Future<Result<UserDto>> getCurrentUser() async {
    try {
      final response = await _authenticationClient.get<Object>('/api/users/me');
      final json = response.asJsonMap();

      if (json == null) {
        return Err(ServerException('Invalid me response payload'));
      }

      final dto = ApiResponseUserDto.fromJson(json);
      return Ok(dto.data ?? UserDto.fromJson(json));
    } on DioException catch (e, st) {
      GsLogger().e('getCurrentUser', e, st);
      return Err(e.toAppException(), st);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _authenticationClient.post<Object>('/api/auth/logout');
      return const Ok(null);
    } on DioException catch (e, st) {
      GsLogger().e('logout', e, st);
      return Err(e.toAppException(), st);
    }
  }

  @override
  Future<Result<UserDto>> updateCurrentUser({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    try {
      final request = UpdateUserRequestDto(
        firstName: firstName?.trim().isEmpty ?? true ? null : firstName?.trim(),
        lastName: lastName?.trim().isEmpty ?? true ? null : lastName?.trim(),
        email: email?.trim().isEmpty ?? true ? null : email?.trim(),
      );
      final response = await _authenticationClient.put<Object>(
        '/api/users/me',
        data: request.toJson(),
      );
      final json = response.asJsonMap();
      if (json == null) {
        return Err(ServerException('Invalid update me response payload'));
      }

      final dto = ApiResponseUserDto.fromJson(json);
      return Ok(dto.data ?? UserDto.fromJson(json));
    } on DioException catch (e, st) {
      GsLogger().e('updateCurrentUser', e, st);
      return Err(e.toAppException(), st);
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final request = ChangePasswordRequestDto(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      await _authenticationClient.put<Object>(
        '/api/users/me/password',
        data: request.toJson(),
      );
      return const Ok(null);
    } on DioException catch (e, st) {
      GsLogger().e('changePassword', e, st);
      return Err(e.toAppException(), st);
    }
  }

  @override
  Future<Result<LoginResponseDto>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final request = RefreshTokenRequestDto(refreshToken: refreshToken);
      final response = await _authenticationClient.post<Object>(
        '/api/auth/refresh',
        data: request.toJson(),
      );
      final json = response.asJsonMap();
      if (json == null) {
        return Err(ServerException('Invalid refresh response payload'));
      }

      final dto = ApiResponseLoginDto.fromJson(json);
      return Ok(dto.data ?? LoginResponseDto.fromJson(json));
    } on DioException catch (e, st) {
      GsLogger().e('refreshToken', e, st);
      return Err(e.toAppException(), st);
    }
  }

  @override
  Future<Result<LoginResponseDto>> signInWithEmailAndPassword({
    required String mail,
    required String password,
  }) async {
    try {
      final request = LoginRequestDto(email: mail, password: password);

      final response = await _authenticationClient.post<Object>(
        '/api/auth/login',
        data: request.toJson(),
      );

      GsLogger().d('signInWithEmailAndPassword response', response.data);

      final json = response.asJsonMap();
      if (json == null) {
        return Err(ServerException('Invalid sign-in response payload'));
      }

      final dto = ApiResponseLoginDto.fromJson(json);
      return Ok(dto.data ?? LoginResponseDto.fromJson(json));
    } on DioException catch (e, st) {
      GsLogger().e('signInWithEmailAndPassword', e, st);
      return Err(e.toAppException(), st);
    }
  }

  @override
  Future<Result<RegisterResponseDto>> signup({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final request = RegisterRequestDto(
        firstName: firstName,
        lastName: lastName,
        email: mail,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      final response = await _authenticationClient.post<Object>(
        '/api/auth/register',
        data: request.toJson(),
      );
      final json = response.asJsonMap();

      if (json == null) {
        return Err(ServerException('Invalid sign-up response payload'));
      }

      final dto = ApiResponseRegisterDto.fromJson(json);
      return Ok(dto.data ?? RegisterResponseDto.fromJson(json));
    } on DioException catch (e, st) {
      GsLogger().e('signup', e, st);
      return Err(e.toAppException(), st);
    }
  }
}
