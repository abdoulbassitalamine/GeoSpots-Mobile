import 'exception.dart';

class HttpException extends ServerException {
  factory HttpException.fromStatusCode(int statusCode) {
    return switch (statusCode) {
      204 => NoContentException(),
      400 => BadRequestException(),
      401 => UnauthorizedException(),
      404 => NotFoundException(),
      500 => InternalServerErrorException(),
      503 => ServiceUnavailableException(),
      _ => throw HttpException('Unknown error occurred', statusCode),
    };
  }

  HttpException(super.message, this.code);

  final int code;

  static void throwFromStatusCode(int statusCode) =>
      throw (HttpException.fromStatusCode(statusCode));

  @override
  String toString() => 'HttpException($code): $message';
}

class NoContentException extends HttpException {
  NoContentException() : super('No content available', 204);

  @override
  String toString() => 'NoContentException: No content available';
}

class NotFoundException extends HttpException {
  NotFoundException() : super('Resource not found', 404);

  @override
  String toString() => 'NotFoundException: Resource not found';
}

class UnauthorizedException extends HttpException {
  UnauthorizedException() : super('Unauthorized access', 401);

  @override
  String toString() => 'UnauthorizedException: Unauthorized access';
}

class BadRequestException extends HttpException {
  BadRequestException() : super('Bad request', 400);

  @override
  String toString() => 'BadRequestException: Bad request';
}

class InternalServerErrorException extends HttpException {
  InternalServerErrorException() : super('Internal server error', 500);

  @override
  String toString() => 'InternalServerErrorException: Internal server error';
}

class ServiceUnavailableException extends HttpException {
  ServiceUnavailableException() : super('Service unavailable', 503);

  @override
  String toString() => 'ServiceUnavailableException: Service unavailable';
}
