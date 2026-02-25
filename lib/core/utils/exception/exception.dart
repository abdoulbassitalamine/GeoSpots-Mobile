export 'http_exception.dart';

abstract class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  String toString() {
    if (message != null && message!.isNotEmpty) {
      return '$runtimeType: $message';
    } else {
      return '$runtimeType: An exception occurred';
    }
  }
}

class ClientException extends AppException {
  const ClientException([super.message]);
}

class ServerException extends AppException {
  const ServerException([super.message]);
}

class ParsingException extends AppException {
  const ParsingException([super.message]);
}

class UnknownException extends AppException {
  const UnknownException([super.message]);
}
