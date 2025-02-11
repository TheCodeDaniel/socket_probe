import 'package:equatable/equatable.dart';

/// Base class for all Dashboard events.
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initiate a connection.
class ConnectRequested extends DashboardEvent {}

/// Event to close the connection.
class DisconnectRequested extends DashboardEvent {}

/// Event to send a plain text message.
class SendMessageRequested extends DashboardEvent {
  final String message;

  const SendMessageRequested(this.message);

  @override
  List<Object?> get props => [message];
}

/// Event to send a JSON message.
class SendJsonRequested extends DashboardEvent {
  final Map<String, dynamic> data;

  const SendJsonRequested(this.data);

  @override
  List<Object?> get props => [data];
}

/// Internal event triggered when a new message is received.
class MessageReceived extends DashboardEvent {
  final dynamic message;

  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

/// Internal event triggered when an error occurs on the connection.
class ConnectionErrorOccurred extends DashboardEvent {
  final String error;

  const ConnectionErrorOccurred(this.error);

  @override
  List<Object?> get props => [error];
}
