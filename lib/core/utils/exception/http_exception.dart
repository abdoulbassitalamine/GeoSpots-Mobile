

import 'package:geo_spots/core/utils/exception/exception.dart';

class HttpException extends ServerException {
  factory HttpException.fromStatusCode(int statusCode) {
    return switch (statusCode) {
      // 2xx - Success but treated as exception in some contexts
      204 => NoContentException(),

      // 4xx - Client errors
      400 => BadRequestException(),
      401 => UnauthorizedException(),
      402 => PaymentRequiredException(),
      403 => ForbiddenException(),
      404 => NotFoundException(),
      405 => MethodNotAllowedException(),
      406 => NotAcceptableException(),
      408 => RequestTimeoutException(),
      409 => ConflictException(),
      410 => GoneException(),
      413 => PayloadTooLargeException(),
      415 => UnsupportedMediaTypeException(),
      422 => UnprocessableEntityException(),
      423 => LockedException(),
      429 => TooManyRequestsException(),
      451 => UnavailableForLegalReasonsException(),

      // 5xx - Server errors
      500 => InternalServerErrorException(),
      501 => NotImplementedException(),
      502 => BadGatewayException(),
      503 => ServiceUnavailableException(),
      504 => GatewayTimeoutException(),
      505 => HttpVersionNotSupportedException(),

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

// ─── 2xx ──────────────────────────────────────────────────────────────────────

class NoContentException extends HttpException {
  NoContentException() : super('No content available', 204);

  @override
  String toString() => 'NoContentException(204): No content available';
}

// ─── 4xx ──────────────────────────────────────────────────────────────────────

class BadRequestException extends HttpException {
  BadRequestException([String? details])
      : super(details ?? 'Bad request — invalid syntax or parameters', 400);

  @override
  String toString() => 'BadRequestException(400): $message';
}

class UnauthorizedException extends HttpException {
  UnauthorizedException()
      : super('Unauthorized — authentication required or token expired', 401);

  @override
  String toString() => 'UnauthorizedException(401): $message';
}

class PaymentRequiredException extends HttpException {
  PaymentRequiredException()
      : super('Payment required to access this resource', 402);

  @override
  String toString() => 'PaymentRequiredException(402): $message';
}

class ForbiddenException extends HttpException {
  ForbiddenException()
      : super('Forbidden — insufficient permissions to access this resource',
            403);

  @override
  String toString() => 'ForbiddenException(403): $message';
}

class NotFoundException extends HttpException {
  NotFoundException() : super('Resource not found', 404);

  @override
  String toString() => 'NotFoundException(404): $message';
}

class MethodNotAllowedException extends HttpException {
  MethodNotAllowedException()
      : super('HTTP method not allowed on this endpoint', 405);

  @override
  String toString() => 'MethodNotAllowedException(405): $message';
}

class NotAcceptableException extends HttpException {
  NotAcceptableException()
      : super('Server cannot produce a response matching the accepted types',
            406);

  @override
  String toString() => 'NotAcceptableException(406): $message';
}

class RequestTimeoutException extends HttpException {
  RequestTimeoutException()
      : super('Request timed out — server did not receive a timely request',
            408);

  @override
  String toString() => 'RequestTimeoutException(408): $message';
}

class ConflictException extends HttpException {
  ConflictException([String? details])
      : super(details ?? 'Conflict — resource already exists or state mismatch',
            409);

  @override
  String toString() => 'ConflictException(409): $message';
}

class GoneException extends HttpException {
  GoneException()
      : super('Resource is permanently deleted and no longer available', 410);

  @override
  String toString() => 'GoneException(410): $message';
}

class PayloadTooLargeException extends HttpException {
  PayloadTooLargeException()
      : super('Request payload exceeds the server size limit', 413);

  @override
  String toString() => 'PayloadTooLargeException(413): $message';
}

class UnsupportedMediaTypeException extends HttpException {
  UnsupportedMediaTypeException()
      : super('Media type not supported by the server', 415);

  @override
  String toString() => 'UnsupportedMediaTypeException(415): $message';
}

class UnprocessableEntityException extends HttpException {
  UnprocessableEntityException([String? details])
      : super(
            details ??
                'Unprocessable entity — validation failed or semantic errors',
            422);

  @override
  String toString() => 'UnprocessableEntityException(422): $message';
}

class LockedException extends HttpException {
  LockedException() : super('Resource is locked and cannot be modified', 423);

  @override
  String toString() => 'LockedException(423): $message';
}

class TooManyRequestsException extends HttpException {
  TooManyRequestsException()
      : super('Too many requests — rate limit exceeded, please retry later',
            429);

  @override
  String toString() => 'TooManyRequestsException(429): $message';
}

class UnavailableForLegalReasonsException extends HttpException {
  UnavailableForLegalReasonsException()
      : super('Resource unavailable for legal reasons', 451);

  @override
  String toString() => 'UnavailableForLegalReasonsException(451): $message';
}

// ─── 5xx ──────────────────────────────────────────────────────────────────────

class InternalServerErrorException extends HttpException {
  InternalServerErrorException()
      : super('Internal server error — unexpected condition on server', 500);

  @override
  String toString() => 'InternalServerErrorException(500): $message';
}

class NotImplementedException extends HttpException {
  NotImplementedException()
      : super('Functionality not implemented by the server', 501);

  @override
  String toString() => 'NotImplementedException(501): $message';
}

class BadGatewayException extends HttpException {
  BadGatewayException()
      : super('Bad gateway — upstream server returned an invalid response',
            502);

  @override
  String toString() => 'BadGatewayException(502): $message';
}

class ServiceUnavailableException extends HttpException {
  ServiceUnavailableException()
      : super('Service unavailable — server is down or overloaded', 503);

  @override
  String toString() => 'ServiceUnavailableException(503): $message';
}

class GatewayTimeoutException extends HttpException {
  GatewayTimeoutException()
      : super('Gateway timeout — upstream server did not respond in time', 504);

  @override
  String toString() => 'GatewayTimeoutException(504): $message';
}

class HttpVersionNotSupportedException extends HttpException {
  HttpVersionNotSupportedException()
      : super('HTTP version used in the request is not supported', 505);

  @override
  String toString() => 'HttpVersionNotSupportedException(505): $message';
}
