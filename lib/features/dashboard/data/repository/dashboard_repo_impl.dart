import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class DashboardRepoImpl {
  final String socketUrl;
  WebSocketChannel? _channel;

  // A broadcast controller lets multiple listeners receive the stream of messages.
  final StreamController<dynamic> _messageController = StreamController<dynamic>.broadcast();

  DashboardRepoImpl(this.socketUrl);

  /// Establishes the WebSocket connection and sets up message listeners.
  void connect() {
    final Uri websocketUri = Uri.parse(socketUrl);

    try {
      _channel = WebSocketChannel.connect(websocketUri);

      // Listen for incoming messages.
      _channel?.stream.listen(
        (message) {
          // Forward the incoming message to listeners.
          _messageController.add(message);
        },
        onError: (error) {
          // Forward errors to listeners.
          _messageController.addError(error);
        },
        onDone: () {
          // Optionally notify listeners that the connection has closed.
          _messageController.add('Connection closed');
        },
        cancelOnError: true,
      );
    } catch (e) {
      // Forward any connection errors.
      _messageController.addError(e);
    }
  }

  /// Returns a stream of messages from the WebSocket.
  Stream<dynamic> get messages => _messageController.stream;

  /// Sends a plain text message over the WebSocket.
  void sendMessage(String message) {
    if (_channel != null) {
      _channel?.sink.add(message);
    } else {
      throw Exception("WebSocket connection is not established. Call connect() first.");
    }
  }

  /// Sends a JSON-encoded message over the WebSocket.
  void sendJson(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    sendMessage(jsonString);
  }

  /// Closes the WebSocket connection.
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
