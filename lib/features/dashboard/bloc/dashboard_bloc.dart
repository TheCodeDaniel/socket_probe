import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/features/dashboard/bloc/dashboard_event.dart';
import 'package:socket_probe/features/dashboard/bloc/dashboard_state.dart';
import 'package:socket_probe/features/dashboard/data/repository/dashboard_repo_impl.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepoImpl repository;
  StreamSubscription? _messageSubscription;
  final List<dynamic> _messages = [];

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    // Event handler for connecting.
    on<ConnectRequested>(_onConnectRequested);
    // Event handler for disconnecting.
    on<DisconnectRequested>(_onDisconnectRequested);
    // Event handler for sending plain text messages.
    on<SendMessageRequested>(_onSendMessageRequested);
    // Event handler for sending JSON messages.
    on<SendJsonRequested>(_onSendJsonRequested);
    // Internal event for incoming messages.
    on<MessageReceived>(_onMessageReceived);
    // Internal event for connection errors.
    on<ConnectionErrorOccurred>(_onConnectionErrorOccurred);
  }

  Future<void> _onConnectRequested(ConnectRequested event, Emitter<DashboardState> emit) async {
    emit(DashboardConnecting());
    try {
      repository.connect();
      // Listen for messages from the repository.
      _messageSubscription = repository.messages.listen(
        (message) {
          add(MessageReceived(message));
        },
        onError: (error) {
          add(ConnectionErrorOccurred(error.toString()));
        },
        onDone: () {
          // When the connection is closed from the repository side.
          add(DisconnectRequested());
        },
      );
      // Once connected, emit the connected state.
      emit(DashboardConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onDisconnectRequested(DisconnectRequested event, Emitter<DashboardState> emit) async {
    repository.disconnect();
    _messages.clear();
    await _messageSubscription?.cancel();
    emit(DashboardDisconnected());
  }

  Future<void> _onSendMessageRequested(SendMessageRequested event, Emitter<DashboardState> emit) async {
    try {
      repository.sendMessage(event.message);
      // Optionally, log the sent message.
      _messages.add("Sent: ${event.message}");
      emit(DashboardConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onSendJsonRequested(SendJsonRequested event, Emitter<DashboardState> emit) async {
    try {
      repository.sendJson(event.data);
      _messages.add("Sent JSON: ${event.data}");
      emit(DashboardConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onMessageReceived(MessageReceived event, Emitter<DashboardState> emit) async {
    // Log the incoming message.
    _messages.add("Received: ${event.message}");
    emit(DashboardConnected(messages: List.from(_messages)));
  }

  Future<void> _onConnectionErrorOccurred(ConnectionErrorOccurred event, Emitter<DashboardState> emit) async {
    emit(DashboardError(event.error));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    repository.disconnect();
    return super.close();
  }
}
