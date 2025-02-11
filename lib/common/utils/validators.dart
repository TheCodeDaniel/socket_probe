class Validators {
  static bool isValidWebSocketUrl(String url) {
    final regex = RegExp(
      r'^(wss?):\/\/(?:(?:[a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,}|\d{1,3}(?:\.\d{1,3}){3})(?::\d+)?(?:\/.*)?$',
    );
    return regex.hasMatch(url);
  }
}
