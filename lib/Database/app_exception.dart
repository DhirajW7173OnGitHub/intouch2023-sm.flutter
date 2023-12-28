class AppException implements Exception {
  AppException([
    this.message,
    this.prefix,
    this.url,
  ]);
  final String? message;
  final String? prefix;
  final String? url;
}

class BadRequestException extends AppException {
  BadRequestException([
    String? message,
    String? url,
  ]) : super(message, 'Bad Request', url);
}

class FetchDataException extends AppException {
  FetchDataException([
    String? message,
    String? url,
  ]) : super(message, 'Unable to process', url);
}

class ApiNotResponseException extends AppException {
  ApiNotResponseException([
    String? message,
    String? url,
  ]) : super(message, 'API not response in time', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([
    String? message,
    String? url,
  ]) : super(message, 'Un-Authorized request', url);
}
