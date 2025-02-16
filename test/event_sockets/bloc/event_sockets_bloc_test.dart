import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socket_probe/features/event_sockets/bloc/event_sockets_bloc.dart';
import 'package:socket_probe/features/event_sockets/bloc/event_sockets_event.dart';
import 'package:socket_probe/features/event_sockets/bloc/event_sockets_state.dart';

void main() {
  group(EventSocketsBloc, () {
    late EventSocketsBloc eventSocketsBloc;

    setUp(() {
      eventSocketsBloc = EventSocketsBloc();
    });

    blocTest(
      'This test the websocket connection when ConnectedRequest is added',
      build: () => eventSocketsBloc,
      act: (bloc) => bloc.add(
        ConnectRequested(socketUrl: 'wss://echo.websocket.events', sockedConfigurations: {
          "auth": {"token": "userToken"},
          "transports": ["websocket"],
          "autoConnect": true,
        }),
      ),
      expect: () => [
        isA<EventSocketsConnecting>(),
        isA<EventSocketsConnected>(),
      ],
    );

    blocTest(
      'This test the websocket connection when DisconnectRequested is added',
      build: () => eventSocketsBloc,
      act: (bloc) => bloc.add(DisconnectRequested()),
      expect: () => [isA<EventSocketsDisconnected>()],
    );

    blocTest(
      'This test the websocket connection when SendMessageRequested is added',
      build: () => eventSocketsBloc,
      act: (bloc) => bloc.add(
        SendMessageRequested(message: "Send Message Requested", event: "message.event"),
      ),
      expect: () => [isA<EventSocketsConnected>()],
    );

    blocTest(
      'This test the websocket connection when MessageReceived is added',
      build: () => eventSocketsBloc,
      act: (bloc) => bloc.add(
        MessageReceived(message: "Message Received"),
      ),
      expect: () => [isA<EventSocketsConnected>()],
    );

    blocTest(
      'This test the websocket connection when ConnectionErrorOccurred is added',
      build: () => eventSocketsBloc,
      act: (bloc) => bloc.add(
        ConnectionErrorOccurred(message: "Connection Error Occurred"),
      ),
      expect: () => [isA<EventSocketsError>()],
    );

    tearDown(() => eventSocketsBloc.close());

    // end of test
  });
}
