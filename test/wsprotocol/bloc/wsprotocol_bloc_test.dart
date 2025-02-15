// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_bloc.dart';
// import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_event.dart';
// import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_state.dart';
// import 'package:socket_probe/features/wsprotocol/data/repository/wsprotocol_repo_impl.dart';
// import 'dart:async';

// class MockWsprotocolRepo extends Mock implements WsprotocolRepoImpl {
//   @override
//   void connect() {
//     // Do nothing to avoid real WebSocket initialization
//   }
// }

// void main() {
//   late WsprotocolBloc bloc;
//   late MockWsprotocolRepo mockRepo;
//   late StreamController<dynamic> messageController;

//   setUp(() {
//     mockRepo = MockWsprotocolRepo();
//     messageController = StreamController<dynamic>.broadcast();

//     // Stub repository methods
//     when(() => mockRepo.messages).thenAnswer((_) => messageController.stream);
//     when(() => mockRepo.connect()).thenReturn(null);
//     when(() => mockRepo.disconnect()).thenReturn(null);

//     bloc = WsprotocolBloc(repo: mockRepo); // Inject mock repository
//   });

//   tearDown(() {
//     bloc.close();
//     messageController.close();
//   });

//   test('initial state is WsprotocolInitial', () {
//     expect(bloc.state, WsprotocolInitial());
//   });

//   blocTest<WsprotocolBloc, WsprotocolState>(
//     'emits [WsprotocolConnecting, WsprotocolConnected] when ConnectRequested is added',
//     build: () {
//       when(() => mockRepo.connect()).thenAnswer((_) {});
//       return bloc;
//     },
//     act: (bloc) => bloc.add(ConnectRequested()),
//     expect: () => [
//       WsprotocolConnecting(),
//       WsprotocolConnected(messages: []),
//     ],
//   );

//   blocTest<WsprotocolBloc, WsprotocolState>(
//     'emits [WsprotocolError] when connection fails',
//     build: () {
//       when(() => mockRepo.connect()).thenThrow(Exception("Connection failed"));
//       return bloc;
//     },
//     act: (bloc) => bloc.add(ConnectRequested()),
//     expect: () => [
//       WsprotocolConnecting(),
//       WsprotocolError("Exception: Connection failed"),
//     ],
//   );

//   blocTest<WsprotocolBloc, WsprotocolState>(
//     'emits [WsprotocolConnected] when a message is received',
//     build: () {
//       return bloc;
//     },
//     act: (bloc) {
//       messageController.add("New message");
//     },
//     expect: () => [
//       WsprotocolConnected(messages: ["Received: New message"]),
//     ],
//   );

//   blocTest<WsprotocolBloc, WsprotocolState>(
//     'emits [WsprotocolDisconnected] when DisconnectRequested is added',
//     build: () {
//       when(() => mockRepo.disconnect()).thenAnswer((_) {});
//       return bloc;
//     },
//     act: (bloc) => bloc.add(DisconnectRequested()),
//     expect: () => [
//       WsprotocolDisconnected(),
//     ],
//   );
// }
