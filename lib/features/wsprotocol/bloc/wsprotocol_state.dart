import 'package:equatable/equatable.dart';

/// Base class for all Dashboard states.
abstract class WsprotocolState extends Equatable {
  const WsprotocolState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action has been taken.
class WsprotocolInitial extends WsprotocolState {}

/// State when attempting to connect.
class WsprotocolConnecting extends WsprotocolState {}

/// State when connected. It holds a list of messages (both sent and received) for display.
class WsprotocolConnected extends WsprotocolState {
  final List<dynamic> messages;

  const WsprotocolConnected({required this.messages});

  @override
  List<Object?> get props => [messages];
}

/// State when disconnected.
class WsprotocolDisconnected extends WsprotocolState {}

/// State when an error has occurred.
class WsprotocolError extends WsprotocolState {
  final String error;

  const WsprotocolError(this.error);

  @override
  List<Object?> get props => [error];
}
