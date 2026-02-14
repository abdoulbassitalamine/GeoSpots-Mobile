import 'package:dio/dio.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:geo_spots/core/utils/extensions/string_ext.dart';

const _kAuthorizationHeader = 'Authorization';
const _kContentTypeHeader = 'Content-Type';
const _kAcceptHeader = 'Accept';

class AuthenticationInterceptor extends Interceptor {
  AuthenticationInterceptor({required this.ref});

  final Ref ref;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authUserRecord = await ref
        .read(authenticationLocalDatasourceProvider)
        .getAuthUserToken();

    GsLogger().d('**** request: ${options.path}');
    if (authUserRecord != null) {
      options.headers[_kAuthorizationHeader] = 'Bearer $authUserRecord';

      if (options.data is! FormData) {
        options.headers[_kContentTypeHeader] = 'application/json';
      }
    }
    //options.headers[_kContentTypeHeader] = 'application/json';
    options.headers[_kAcceptHeader] = 'application/json';

    GsLogger().d('**** HEADERS: ${options.headers.toString()}');
    GsLogger().d('**** BODY: ${options.data.toString()}');

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    GsLogger().d(err.response);
    if (err.response?.statusCode == 401) {
      final authUserRecord = await ref
          .read(authenticationLocalDatasourceProvider)
          .getAuthUserToken();
      if (!authUserRecord.isNullOrEmpty) {
        await ref
            .read(authenticationLocalDatasourceProvider)
            .setTokenValidity(false);
        ref
            .read(authenticationNotifierProvider.notifier)
            .updateState(const AuthenticationStatus.unauthenticated(true));
      }
    }
    handler.next(err);
  }
}
