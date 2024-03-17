class CacheException implements Exception {
  String message;
  CacheException({this.message = ''});
}

class ServerException implements Exception {
  String message;
  ServerException({this.message = ''});
}
