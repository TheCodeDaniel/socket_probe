import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_bloc.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_event.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_state.dart';

void main() {
  group(WsprotocolBloc, () {
    late WsprotocolBloc wsprotocolBloc;

    setUp(() {
      wsprotocolBloc = WsprotocolBloc();
    });

    blocTest(
      'This test the websocket connection when ConnectedRequest is added',
      build: () => wsprotocolBloc,
      act: (bloc) => bloc.add(ConnectRequested(socketUrl: 'wss://echo.websocket.events')),
      expect: () => [
        isA<WsprotocolConnecting>(),
        isA<WsprotocolConnected>(),
      ],
    );

    blocTest(
      'This test the websocket when DisconnectRequest is added',
      build: () => wsprotocolBloc,
      act: (bloc) => bloc.add(DisconnectRequested()),
      expect: () => [
        isA<WsprotocolDisconnected>(),
      ],
    );

    blocTest(
      'This test the websocket when SendMessageRequest is added',
      build: () => wsprotocolBloc,
      act: (bloc) => bloc.add(SendMessageRequested("Send Message Requested")),
      expect: () => [
        isA<WsprotocolConnected>(),
      ],
    );

    blocTest(
      'This test the websocket when MessageReceived is added',
      build: () => wsprotocolBloc,
      act: (bloc) => bloc.add(MessageReceived('Message Received')),
      expect: () => [
        isA<WsprotocolConnected>(),
      ],
    );

    blocTest(
      'This test the websocket when ConnectionErrorOccurred is added',
      build: () => wsprotocolBloc,
      act: (bloc) => bloc.add(ConnectionErrorOccurred("Connect Error Occurred")),
      expect: () => [
        isA<WsprotocolError>(),
      ],
    );

    tearDown(() {
      wsprotocolBloc.close();
    });
  });
}
