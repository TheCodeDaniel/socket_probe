import 'package:equatable/equatable.dart';

abstract class EventSocketsState extends Equatable {
  const EventSocketsState();

  @override
  List<Object?> get props => [];
}

class EventSocketsInitial extends EventSocketsState {}

class EventSocketsConnecting extends EventSocketsState {}

class EventSocketsConnected extends EventSocketsState {
  final List<dynamic> messages;
  const EventSocketsConnected({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class EventSocketsDisconnected extends EventSocketsState {}

class EventSocketsError extends EventSocketsState {
  final String error;
  const EventSocketsError({required this.error});

  @override
  List<Object?> get props => [error];
}
