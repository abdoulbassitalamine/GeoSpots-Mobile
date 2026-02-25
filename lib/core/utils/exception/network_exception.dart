import 'package:geo_spots/core/utils/exception/exception.dart';

class NetworkException extends AppException {
  const NetworkException([super.message]);
}

class NetworkConnectionException extends NetworkException {
  const NetworkConnectionException([super.message]);
}

class NetworkTimeoutException extends NetworkException {
  const NetworkTimeoutException([super.message]);
}

class RequestCancelledException extends NetworkException {
  const RequestCancelledException([super.message]);
}
