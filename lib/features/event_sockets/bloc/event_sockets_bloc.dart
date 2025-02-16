import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/features/event_sockets/bloc/event_sockets_event.dart';

import 'package:socket_probe/features/event_sockets/bloc/event_sockets_state.dart';
import 'package:socket_probe/features/event_sockets/data/repository/event_sockets_repo_impl.dart';

class EventSocketsBloc extends Bloc<EventSocketsEvent, EventSocketsState> {
  EventSocketsRepoImpl _repository = EventSocketsRepoImpl("wss://echo.websocket.events", {
    "auth": {"token": "userToken"},
    "transports": ["websocket"],
    "autoConnect": true,
  });

  StreamSubscription? _messageSubscription;
  final List<dynamic> _messages = [];

  final socketTextController = TextEditingController();

  final eventTextController = TextEditingController();
  final messageTextController = TextEditingController();

  EventSocketsBloc() : super(EventSocketsInitial()) {
    // handle socket connection
    on<ConnectRequested>(_handleConnect);

    // handle socket disconnection
    on<DisconnectRequested>(_onDisconnectRequested);

    // handle message sent
    on<SendMessageRequested>(_onSendMessageSent);

    // handle received messages
    on<MessageReceived>(_onMessageReceived);

    // handle connection error
    on<ConnectionErrorOccurred>(_onConnectionErrorOccurred);
  }

  _handleConnect(ConnectRequested event, Emitter<EventSocketsState> emit) {
    try {
      emit(EventSocketsConnecting());
      _repository = EventSocketsRepoImpl(event.socketUrl, event.sockedConfigurations);

      _repository.connectToSocket();

      _messageSubscription = _repository.messages.listen(
        (event) {
          add(MessageReceived(message: event));
        },
        onError: (error) {
          add(ConnectionErrorOccurred(message: error.toString()));
        },
        onDone: () {
          add(DisconnectRequested());
        },
        cancelOnError: true,
      );

      emit(EventSocketsConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(EventSocketsError(error: e.toString()));
    }
  }

  Future<void> _onDisconnectRequested(DisconnectRequested event, Emitter<EventSocketsState> emit) async {
    try {
      _repository.disconnect();
      _messages.clear();
      await _messageSubscription?.cancel();
      emit(EventSocketsDisconnected());
    } catch (e) {
      emit(EventSocketsError(error: e.toString()));
    }
  }

  Future<void> _onSendMessageSent(SendMessageRequested event, Emitter<EventSocketsState> emit) async {
    try {
      _repository.sendEventMessage(event.event, event.message);
      // Log the sent message.
      _messages.add("Sent: ${event.message}");
      emit(EventSocketsConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(EventSocketsError(error: e.toString()));
    }
  }

  Future<void> _onMessageReceived(MessageReceived event, Emitter<EventSocketsState> emit) async {
    try {
      // Log the incoming message.
      _messages.add("Received: ${event.message}");
      emit(EventSocketsConnected(messages: List.from(_messages)));
    } catch (e) {
      emit(EventSocketsError(error: e.toString()));
    }
  }

  Future<void> _onConnectionErrorOccurred(ConnectionErrorOccurred event, Emitter<EventSocketsState> emit) async {
    emit(EventSocketsError(error: event.message));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _repository.disconnect();
    return super.close();
  }
}
