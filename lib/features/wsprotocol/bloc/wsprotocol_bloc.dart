import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_event.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_state.dart';
import 'package:socket_probe/features/wsprotocol/data/repository/wsprotocol_repo_impl.dart';

class WsprotocolBloc extends Bloc<WsprotocolEvent, WsprotocolState> {
  TextEditingController wssTextController = TextEditingController();
  TextEditingController randomStringController = TextEditingController();

  WsprotocolRepoImpl repository = WsprotocolRepoImpl('wss://echo.websocket.events');
  StreamSubscription? _messageSubscription;
  final List<dynamic> _messages = [];

  WsprotocolBloc() : super(WsprotocolInitial()) {
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

  Future<void> _onConnectRequested(ConnectRequested event, Emitter<WsprotocolState> emit) async {
    emit(WsprotocolConnecting());
    try {
      repository = WsprotocolRepoImpl(event.socketUrl);
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
      emit(WsprotocolConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(WsprotocolError(e.toString()));
    }
  }

  Future<void> _onDisconnectRequested(DisconnectRequested event, Emitter<WsprotocolState> emit) async {
    try {
      repository.disconnect();
      _messages.clear();
      await _messageSubscription?.cancel();
      emit(WsprotocolDisconnected());
    } catch (e) {
      emit(WsprotocolError(e.toString()));
    }
  }

  Future<void> _onSendMessageRequested(SendMessageRequested event, Emitter<WsprotocolState> emit) async {
    try {
      repository.sendMessage(event.message);
      // Optionally, log the sent message.
      _messages.add("Sent: ${event.message}");
      emit(WsprotocolConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(WsprotocolError(e.toString()));
    }
  }

  Future<void> _onSendJsonRequested(SendJsonRequested event, Emitter<WsprotocolState> emit) async {
    try {
      repository.sendJson(event.data);
      _messages.add("Sent JSON: ${event.data}");
      emit(WsprotocolConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(WsprotocolError(e.toString()));
    }
  }

  Future<void> _onMessageReceived(MessageReceived event, Emitter<WsprotocolState> emit) async {
    try {
      // Log the incoming message.
      _messages.add("Received: ${event.message}");
      emit(WsprotocolConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(WsprotocolError(e.toString()));
    }
  }

  Future<void> _onConnectionErrorOccurred(ConnectionErrorOccurred event, Emitter<WsprotocolState> emit) async {
    emit(WsprotocolError(event.error));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    repository.disconnect();
    return super.close();
  }
}
