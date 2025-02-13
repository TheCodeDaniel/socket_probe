import 'package:equatable/equatable.dart';

abstract class EventSocketsEvent extends Equatable {
  const EventSocketsEvent();

  @override
  List<Object?> get props => [];
}

class ConnectRequested extends EventSocketsEvent {
  final String socketUrl;
  final dynamic sockedConfigurations;
  const ConnectRequested({required this.socketUrl, required this.sockedConfigurations});

  @override
  List<Object?> get props => [socketUrl, sockedConfigurations];
}

class DisconnectRequested extends EventSocketsEvent {}

class SendMessageRequested extends EventSocketsEvent {
  final String event;
  final dynamic message;
  const SendMessageRequested({required this.message, required this.event});

  @override
  List<Object?> get props => [message];
}

class MessageReceived extends EventSocketsEvent {
  final dynamic message;
  const MessageReceived({required this.message});

  @override
  List<Object?> get props => [message];
}

class ConnectionErrorOccurred extends EventSocketsEvent {
  final String message;
  const ConnectionErrorOccurred({required this.message});

  @override
  List<Object?> get props => [message];
}
