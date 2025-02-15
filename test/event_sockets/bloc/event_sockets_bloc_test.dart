// import 'dart:async';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:socket_probe/features/event_sockets/bloc/event_sockets_bloc.dart';
// import 'package:socket_probe/features/event_sockets/bloc/event_sockets_event.dart';
// import 'package:socket_probe/features/event_sockets/bloc/event_sockets_state.dart';
// import 'package:socket_probe/features/event_sockets/data/repository/event_sockets_repo_impl.dart';

// // Mock repository class
// class MockEventSocketsRepo extends Mock implements EventSocketsRepoImpl {}

// void main() {
//   late EventSocketsBloc eventSocketsBloc;
//   late MockEventSocketsRepo mockRepository;
//   late StreamController<dynamic> messageController;

//   setUp(() {
//     mockRepository = MockEventSocketsRepo();
//     messageController = StreamController<dynamic>.broadcast();

//     when(() => mockRepository.messages).thenAnswer((_) => messageController.stream);
//     when(() => mockRepository.connectToSocket()).thenAnswer((_) {
//       messageController.add('Connected'); // Simulating successful connection
//     });
//     when(() => mockRepository.disconnect()).thenReturn(null);
//     when(() => mockRepository.sendEventMessage(any(), any())).thenReturn(null);

//     eventSocketsBloc = EventSocketsBloc();
//     // eventSocketsBloc._repository = mockRepository;
//   });

//   tearDown(() {
//     eventSocketsBloc.close();
//     messageController.close();
//   });

//   test('initial state should be EventSocketsInitial', () {
//     expect(eventSocketsBloc.state, equals(EventSocketsInitial()));
//   });

//   blocTest<EventSocketsBloc, EventSocketsState>(
//     'emits [EventSocketsConnecting, EventSocketsConnected] when ConnectRequested is added',
//     build: () => eventSocketsBloc,
//     act: (bloc) => bloc.add(ConnectRequested(socketUrl: 'ws://test-url', sockedConfigurations: {})),
//     expect: () => [
//       EventSocketsConnecting(),
//       EventSocketsConnected(messages: []),
//     ],
//     verify: (_) {
//       verify(() => mockRepository.connectToSocket()).called(1);
//     },
//   );

//   blocTest<EventSocketsBloc, EventSocketsState>(
//     'emits [EventSocketsDisconnected] when DisconnectRequested is added',
//     build: () => eventSocketsBloc,
//     act: (bloc) => bloc.add(DisconnectRequested()),
//     expect: () => [
//       EventSocketsDisconnected(),
//     ],
//     verify: (_) {
//       verify(() => mockRepository.disconnect()).called(1);
//     },
//   );

//   blocTest<EventSocketsBloc, EventSocketsState>(
//     'emits [EventSocketsConnected] when a message is received',
//     build: () => eventSocketsBloc,
//     act: (bloc) {
//       messageController.add('New Event Message');
//       bloc.add(MessageReceived(message: 'New Event Message'));
//     },
//     expect: () => [
//       EventSocketsConnected(messages: ['Received: New Event Message']),
//     ],
//   );

//   blocTest<EventSocketsBloc, EventSocketsState>(
//     'emits [EventSocketsConnected] when SendMessageRequested is added',
//     build: () => eventSocketsBloc,
//     act: (bloc) => bloc.add(SendMessageRequested(event: 'testEvent', message: 'testMessage')),
//     expect: () => [
//       EventSocketsConnected(messages: ['Sent: testMessage']),
//     ],
//     verify: (_) {
//       verify(() => mockRepository.sendEventMessage('testEvent', 'testMessage')).called(1);
//     },
//   );

//   blocTest<EventSocketsBloc, EventSocketsState>(
//     'emits [EventSocketsError] when a connection error occurs',
//     build: () => eventSocketsBloc,
//     act: (bloc) {
//       messageController.addError('Socket connection failed');
//       bloc.add(ConnectionErrorOccurred(message: 'Socket connection failed'));
//     },
//     expect: () => [
//       EventSocketsError(error: 'Socket connection failed'),
//     ],
//   );
// }
