class ConnectionTimeoutException implements Exception {
  const ConnectionTimeoutException();

  @override
  String toString() {
    return "Connection timed out. Please check your internet connection or try again later.";
  }
}

class NoInternetConnectionException implements Exception {
  const NoInternetConnectionException();

  @override
  String toString() {
    return "No internet connection available. Please check your network settings and try again.";
  }
}

class DefaultException implements Exception {
  const DefaultException();
  
  @override
  String toString() {
    return "Oops! Something went wrong. Please try again later.";
  }
}
