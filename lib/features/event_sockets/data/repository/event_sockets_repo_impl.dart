import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as sio;

class EventSocketsRepoImpl {
  final String socketUrl;
  final dynamic socketOpts;

  sio.Socket? socket;

  // A broadcast controller lets multiple listeners receive the stream of messages.
  final StreamController<dynamic> _messageController = StreamController<dynamic>.broadcast();

  EventSocketsRepoImpl(this.socketUrl, this.socketOpts);

  void connectToSocket() {
    try {
      String url = socketUrl;

      // Connect to the Socket.IO server
      socket = sio.io(url, socketOpts);

      socket?.on('connect', (message) {
        // socket.subEvents();
        _messageController.add(message);
        log('Connected to server');
      });

      socket?.onAny((event, data) {
        _messageController.add(data);
        log("event name: $event, event data: $data");
      });

      socket?.onError((data) {
        _messageController.addError(data);
        log("connection error: $data");
      });

      socket?.onConnectError((data) {
        _messageController.addError(data);
        log("connection error: $data");
      });
    } catch (e) {
      _messageController.addError(e);
    }
  }

  Stream<dynamic> get messages => _messageController.stream;

  void sendEventMessage(String event, [dynamic data]) {
    if (socket == null) return;
    if (socket?.connected ?? false) {
      socket?.emit(event, data);
    } else {
      throw Exception("WebSocket connection is not established. Call connect() first.");
    }
  }

  void disconnect() {
    if (socket == null) return;
    if (socket?.connected ?? false) {
      socket?.disconnect();
      log('disconnected from server');
    }
  }
}
