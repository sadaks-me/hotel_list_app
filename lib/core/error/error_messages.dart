class ErrorMessages {
  static String getErrorMessage(Object error) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return 'No internet connection.\nPlease check your connection and try again.';
    }

    if (error.toString().contains('TimeoutException')) {
      return 'Request timed out.\nPlease try again.';
    }

    if (error.toString().contains('CacheException')) {
      return 'Unable to load cached data.\nPlease refresh to try again.';
    }

    if (error.toString().contains('ServerException')) {
      return 'Server error.\nWe\'re working on it! Please try again later.';
    }

    // Default error message
    return 'Something went wrong.\nPlease try again.';
  }
}
