import 'package:geo_spots/core/utils/exception/exception.dart';

class EmailNotValidSignInException extends ClientException {}

class PasswordNotValidSignInException extends ClientException {}

class WrongEmailOrPasswordException extends ServerException {}

class EmailAlreadyExistsException extends ServerException {}

class SignUpServerException extends ServerException {}
