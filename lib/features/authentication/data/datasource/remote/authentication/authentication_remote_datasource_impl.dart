import 'package:dio/dio.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/exception/dio_exception.dart';
import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/datasource/remote/authentication/authentication_remote_datasource.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/login_request_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/login_response_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/register_request_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/register_response_dto.dart';
import 'package:geo_spots/features/authentication/data/dto/authentication/user_dto.dart';

class AuthenticationRemoteDatasourceImpl
    implements IAuthenticationRemoteDatasource {
  AuthenticationRemoteDatasourceImpl({required Dio authenticationClient})
    : _authenticationClient = authenticationClient;

  final Dio _authenticationClient;

  @override
  Future<Result<UserDto>> getCurrentUser() async {
    try {
      final response = await _authenticationClient.get<Object>('/api/me');
      final json = response.asJsonMap();

      if (json == null) {
        return Err(ServerException('Invalid me response payload'));
      }

      return Ok(UserDto.fromJson(json));
    } on DioException catch (e, st) {
      GsLogger().e('getCurrentUser', e, st);
      return Err(e.toAppException(), st);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _authenticationClient.get<Object>('/api/logout');
      return const Ok(null);
    } on DioException catch (e, st) {
      GsLogger().e('logout', e, st);
      return Err(e.toAppException(), st);
    }
  }

  @override
  Future<Result<LoginResponseDto>> signInWithEmailAndPassword({
    required String mail,
    required String password,
  }) async {
    // TODO(dev): fake response — remove before prod
    // return Ok(
    //   LoginResponseDto(
    //     success: true,
    //     message: 'fake login',
    //     data: AuthSessionDto(
    //       token: 'fake-dev-token-123',
    //       data: UserDto(
    //         id: 1,
    //         name: 'Dev User',
    //         email: mail,
    //         roleId: 3,
    //         status: UserStatus.active,
    //       ),
    //     ),
    //   ),
    // );

    try {
      final request = LoginRequestDto(email: mail, password: password);

      final response = await _authenticationClient.post<Object>(
        '/api/login',
        data: request.toJson(),
      );

      GsLogger().d('signInWithEmailAndPassword response', response.data);

      final json = response.asJsonMap();
      if (json == null) {
        return Err(ServerException('Invalid sign-in response payload'));
      }

      return Ok(LoginResponseDto.fromJson(json));
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
        '/api/register',
        data: request.toJson(),
      );
      final json = response.asJsonMap();

      if (json == null) {
        return Err(ServerException('Invalid sign-up response payload'));
      }

      return Ok(RegisterResponseDto.fromJson(json));
    } on DioException catch (e, st) {
      GsLogger().e('signup', e, st);
      return Err(e.toAppException(), st);
    }
  }
}
