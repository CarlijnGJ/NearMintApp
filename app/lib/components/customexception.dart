class HttpExceptionWithStatusCode implements Exception {
  final String message;
  final int statusCode;

  HttpExceptionWithStatusCode(this.message, this.statusCode);

  @override
  String toString() {
    return 'HttpExceptionWithStatusCode: statusCode=$statusCode, message=$message';
  }
}