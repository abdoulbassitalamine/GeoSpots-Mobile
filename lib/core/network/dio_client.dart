import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geo_spots/features/authentication/data/client/dio/interceptors/authentication_interceptor.dart';
import 'package:geo_spots/features/collections/data/client/interceptors/shared_access_interceptor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL']!,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(AuthenticationInterceptor(ref: ref));
  dio.interceptors.add(SharedAccessInterceptor(ref: ref));

  return dio;
}
