import 'package:equatable/equatable.dart';

/// Base class for all Dashboard events.
abstract class WsprotocolEvent extends Equatable {
  const WsprotocolEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initiate a connection.
class ConnectRequested extends WsprotocolEvent {
  final String socketUrl;
  const ConnectRequested({required this.socketUrl});

  @override
  List<Object?> get props => [socketUrl];
}

/// Event to close the connection.
class DisconnectRequested extends WsprotocolEvent {}

/// Event to send a plain text message.
class SendMessageRequested extends WsprotocolEvent {
  final String message;

  const SendMessageRequested(this.message);

  @override
  List<Object?> get props => [message];
}

/// Event to send a JSON message.
class SendJsonRequested extends WsprotocolEvent {
  final Map<String, dynamic> data;

  const SendJsonRequested(this.data);

  @override
  List<Object?> get props => [data];
}

/// Internal event triggered when a new message is received.
class MessageReceived extends WsprotocolEvent {
  final dynamic message;

  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

/// Internal event triggered when an error occurs on the connection.
class ConnectionErrorOccurred extends WsprotocolEvent {
  final String error;

  const ConnectionErrorOccurred(this.error);

  @override
  List<Object?> get props => [error];
}
