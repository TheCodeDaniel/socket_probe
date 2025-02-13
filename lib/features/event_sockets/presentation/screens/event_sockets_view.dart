import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/common/utils/dialogs.dart';
import 'package:socket_probe/common/utils/validators.dart';
import 'package:socket_probe/common/widgets/app_button.dart';
import 'package:socket_probe/common/widgets/app_textfield.dart';
import 'package:socket_probe/features/event_sockets/bloc/event_sockets_bloc.dart';
import 'package:socket_probe/features/event_sockets/bloc/event_sockets_event.dart';
import 'package:socket_probe/features/event_sockets/bloc/event_sockets_state.dart';

class EventSocketsView extends StatefulWidget {
  const EventSocketsView({super.key});

  @override
  State<EventSocketsView> createState() => _EventSocketsViewState();
}

class _EventSocketsViewState extends State<EventSocketsView> {
  late EventSocketsBloc socketBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    socketBloc = context.read();
    super.initState();
  }

  dynamic defaultParamList = <String, dynamic>{
    'auth': {
      'token': '',
    },
    'transports': ['websocket'],
    'autoConnect': true,
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<EventSocketsBloc, EventSocketsState>(
      listener: (context, state) {
        if (state is EventSocketsError) {
          Dialogs().showInfoDialog(context, message: state.error);
        }
      },
      child: BlocBuilder<EventSocketsBloc, EventSocketsState>(
        builder: (context, state) {
          bool isLoading = (state is EventSocketsConnecting);
          bool connected = (state is EventSocketsConnected);

          return Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 15,
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: AppTextField(
                        hintText: "https://testsocket.net OR wss://testsocket.net",
                        outerTitle: "Socket URL (https/http/wss/ws protocols)",
                        controller: socketBloc.socketTextController,
                        validator: (val) {
                          if (val != null && !Validators.isValidHttpUrl(val)) return 'Provide a valid/supported URL';
                          return null;
                        },
                        suffixIcon: SizedBox(
                          width: size.width * 0.15,
                          child: AppButton(
                            bgColor: connected ? Colors.red : Colors.green,
                            onPressed: () {
                              if (!(_formKey.currentState?.validate() ?? false)) return;

                              if (connected) {
                                socketBloc.add(DisconnectRequested());
                                return;
                              }
                              socketBloc.add(ConnectRequested(
                                socketUrl: socketBloc.socketTextController.text,
                                sockedConfigurations: defaultParamList,
                              ));
                            },
                            content: isLoading
                                ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                                : Text(connected ? "Close connection" : "Open Connection"),
                          ),
                        ),
                      ),
                    ),

                    // socket connection status row
                    Row(
                      spacing: 5,
                      children: [
                        Text(connected ? 'Connection Opened' : 'Connection closed'),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Icon(
                            Icons.circle,
                            color: connected ? Colors.green : Colors.red,
                            size: 15,
                          ),
                        )
                      ],
                    ),

                    // input fields section
                    if (connected)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // textfield row

                          // display response messages
                          SizedBox(height: 20),
                          Container(
                            width: size.width * 0.8,
                            height: size.height * 0.4,
                            color: Colors.grey.shade100,
                            padding: EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: SelectableText(
                                state.messages.join("\n").toString().replaceAll("[", '').replaceAll("]", ''),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
