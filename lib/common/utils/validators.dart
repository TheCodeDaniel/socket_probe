class Validators {
  static bool isValidWebSocketUrl(String url) {
    final regex = RegExp(
      r'^(wss?):\/\/(?:(?:[a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,}|\d{1,3}(?:\.\d{1,3}){3})(?::\d+)?(?:\/.*)?$',
    );
    return regex.hasMatch(url);
  }

  static bool isValidHttpUrl(String url) {
    final urlRegex = RegExp(
      r'^(https?|wss?):\/\/' // Protocol: http, https, ws, wss
      r'(?:(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}|' // Domain name
      r'(?:\d{1,3}\.){3}\d{1,3})' // OR IPv4 address
      r'(?::\d+)?' // Optional port
      r'(?:\/[^\s]*)?$', // Optional path, query, fragment
    );
    return urlRegex.hasMatch(url);
  }
}
