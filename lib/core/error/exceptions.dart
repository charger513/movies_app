class ServerException implements Exception {}

class UnauthenticatedException implements Exception {
  final String message;

  UnauthenticatedException(this.message);
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}

class UnknownException implements Exception {}
