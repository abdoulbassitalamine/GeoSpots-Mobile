import 'package:dio/dio.dart';
import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/core/utils/exception/network_exception.dart';

extension DioResponseExt on Response<Object> {
  /// Caste `response.data` en `Map<String, dynamic>` utilisable par les DTOs.
  /// Retourne `null` si la réponse n'est pas un objet JSON.
  Map<String, dynamic>? asJsonMap() {
    final data = this.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    return null;
  }
}

extension DioExceptionMapper on DioException {
  AppException toAppException() {
    final statusCode = response?.statusCode;
    if (statusCode != null) {
      return HttpException.fromStatusCode(statusCode);
    }

    return switch (type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const NetworkTimeoutException(
        'Request timeout',
      ),
      DioExceptionType.connectionError || DioExceptionType.badCertificate =>
        const NetworkConnectionException('Network connection failed'),
      DioExceptionType.cancel => const RequestCancelledException(
        'Request cancelled',
      ),
      _ => UnknownException(message),
    };
  }
}
