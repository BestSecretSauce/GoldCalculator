class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkUnavailableException extends ApiException {
  const NetworkUnavailableException() : super('Network unavailable');
}
