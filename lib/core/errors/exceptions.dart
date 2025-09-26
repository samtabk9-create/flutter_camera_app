class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class CameraException implements Exception {
  final String message;
  CameraException(this.message);
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class PermissionException implements Exception {
  final String message;
  PermissionException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}