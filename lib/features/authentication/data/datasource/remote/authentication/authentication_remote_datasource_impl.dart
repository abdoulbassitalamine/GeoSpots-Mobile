
import 'package:dio/dio.dart';

import '../../../../../../core/logger/gs_logger.dart';
import '../../../../domain/entity/user/user_entity.dart';
import '../../../exception/auth_exception.dart';
import 'authentication_remote_datasource.dart';


class AuthenticationRemoteDatasourceImpl
    implements IAuthenticationRemoteDatasource {
  AuthenticationRemoteDatasourceImpl({required Dio authenticationClient});
  // : _authApi = AuthenticationApi(authenticationClient);

  //final AuthenticationApi _authApi;

  @override
  Future<String> checkTokenValidity() async {
    try {
      // final result = await _authApi.validateToken();
      // if (result.data == null) throw Exception('No user found');
      // return result.data!;
      return 'Valid';
    } on DioException catch (e) {
      GsLogger().e(e);
      throw Exception(e);
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      // final result = await _authApi.me();
      // if (result.data == null) throw Exception('No user found');
      // return result.data!;
      return UserEntity(id: "2");
    } on DioException catch (e) {
      GsLogger().e(e);
      throw Exception(e);
    }
  }

  @override
  Future<String> sendResetPasswordLink(String email) async {
    try {
      // final result = await _authApi.sendPasswordResetEmail(
      //   sendPasswordResetEmailRequestDto: SendPasswordResetEmailRequestDto(
      //     email: email,
      //   ),
      // );
      // if (result.data == null) throw Exception('Cannot send link');
      // return result.data!;

      return "Success";
    } on DioException catch (e, st) {
      GsLogger().e(e, st);
      throw Exception(e);
    }
  }

  @override
  Future<String> signInWithEmailAndPassword({
    required String mail,
    required String password,
  }) async {
    //  final request = LoginRequestDto(email: mail, password: password);

    try {
      // final result = await _authApi.login(loginRequestDto: request);
      // if (result.data == null) throw Exception('No user found');
      //
      // return result.data!;
      return 'Signin';
    } on DioException catch (e) {
      GsLogger().e(e);
      if (e.type == DioExceptionType.badResponse) {
        throw WrongEmailOrPasswordException();
      }
      throw Exception(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      //  await _authApi.logout();
    } on DioException catch (e) {
      GsLogger().e(e);
      throw Exception(e);
    }
  }

  @override
  Future<String?> signup({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  }) async {
    // final signupRequest = RegisterRequestDto(
    //   firstName: firstName,
    //   lastName: lastName,
    //   email: mail,
    //   gender: gender.apiValueRegister,
    //   phoneNumber: phoneNumber,
    //   address: address,
    //   state: State,
    //   city: city,
    //   zipcode: zipCode,
    //   password: password,
    //   passwordConfirmation: passwordConfirmation,
    // );
    try {
      // final result = await _authApi.register(registerRequestDto: signupRequest);
      // if (result.data == null) throw Exception('No Token found');
      // return result.data!.token;
      return 'token';
    } on DioException catch (e) {
      GsLogger().e(e);
      if (e.type == DioExceptionType.badResponse &&
          e.response?.statusCode == 422) {
        throw EmailAlreadyExistsException();
      }
      if (e.type == DioExceptionType.badResponse &&
          e.response?.statusCode == 500) {
        throw SignUpServerException();
      }
      throw Exception(e);
    }
  }

  @override
  Future<String> updateUser(String user) async {
    try {
      // final result = await _authApi.updateUser(updateUserRequestDto: user);
      // if (result.data == null) throw Exception('No user found');
      // return result.data!.user!;
      return 'Update user';
    } on DioException catch (e) {
      GsLogger().e(e);
      throw Exception(e);
    }
  }
}
