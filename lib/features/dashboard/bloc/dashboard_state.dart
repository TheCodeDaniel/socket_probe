import 'package:equatable/equatable.dart';

/// Base class for all Dashboard states.
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action has been taken.
class DashboardInitial extends DashboardState {}

/// State when attempting to connect.
class DashboardConnecting extends DashboardState {}

/// State when connected. It holds a list of messages (both sent and received) for display.
class DashboardConnected extends DashboardState {
  final List<dynamic> messages;

  const DashboardConnected({required this.messages});

  @override
  List<Object?> get props => [messages];
}

/// State when disconnected.
class DashboardDisconnected extends DashboardState {}

/// State when an error has occurred.
class DashboardError extends DashboardState {
  final String error;

  const DashboardError(this.error);

  @override
  List<Object?> get props => [error];
}
