import 'package:dio/dio.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/exception/dio_exception.dart';
import 'package:geo_spots/core/utils/exception/http_exception.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kAuthorizationHeader = 'Authorization';
const _kContentTypeHeader = 'Content-Type';
const _kAcceptHeader = 'Accept';
const _kAccessTokenHeader = 'X-Access-Token';
const kAccessTokenQueryParam = 'token';

class AuthenticationInterceptor extends Interceptor {
  AuthenticationInterceptor({required this.ref});

  final Ref ref;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final localDatasource = ref.read(authenticationLocalDatasourceProvider);
    final tokenResult = await localDatasource.getAuthUserToken();
    final tokenValidityResult = await localDatasource.getTokenValidity();

    final authUserToken = switch (tokenResult) {
      Ok(:final value) => value,
      Err() => null,
    };
    final tokenValidity = switch (tokenValidityResult) {
      Ok(:final value) => value ?? false,
      Err() => false,
    };
    final hasValidToken =
        authUserToken != null && authUserToken.isNotEmpty && tokenValidity;

    GsLogger().d('**** request: ${options.path}');
    if (hasValidToken) {
      options.headers[_kAuthorizationHeader] = 'Bearer $authUserToken';

      if (options.data is! FormData) {
        options.headers[_kContentTypeHeader] = 'application/json';
      }
    }
    //options.headers[_kContentTypeHeader] = 'application/json';
    options.headers[_kAcceptHeader] = 'application/json';

    GsLogger().d('**** QUERY PARAM ${options.queryParameters.toString()}');
    GsLogger().d('**** HEADERS: ${options.headers.toString()}');
    GsLogger().d('**** BODY: ${options.data.toString()}');

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    GsLogger().e(err.response);
    final appException = err.toAppException();
    if (appException is UnauthorizedException) {
      final request = err.requestOptions;
      final hasAuthHeader = _hasNonEmptyHeader(request, _kAuthorizationHeader);
      final hasSharedTokenHeader = _hasNonEmptyHeader(
        request,
        _kAccessTokenHeader,
      );
      final hasSharedTokenQuery =
          request.queryParameters[kAccessTokenQueryParam]
              ?.toString()
              .trim()
              .isNotEmpty ??
          false;

      if (!hasAuthHeader || hasSharedTokenHeader || hasSharedTokenQuery) {
        handler.next(err);
        return;
      }

      final localDatasource = ref.read(authenticationLocalDatasourceProvider);
      await localDatasource.setTokenValidity(false);
      await localDatasource.deleteAuthUser();
      ref
          .read(authGuardProvider.notifier)
          .updateState(const AuthenticationStatus.unauthenticated(true));
    }
    handler.next(err);
  }

  bool _hasNonEmptyHeader(RequestOptions request, String key) {
    final value = request.headers[key];
    if (value == null) {
      return false;
    }
    return value.toString().trim().isNotEmpty;
  }
}
