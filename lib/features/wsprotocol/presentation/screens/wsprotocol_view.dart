import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/common/utils/dialogs.dart';
import 'package:socket_probe/common/utils/validators.dart';
import 'package:socket_probe/common/widgets/app_button.dart';
import 'package:socket_probe/common/widgets/app_textfield.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_bloc.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_event.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_state.dart';

class WsprotocolView extends StatefulWidget {
  const WsprotocolView({super.key});

  @override
  State<WsprotocolView> createState() => _WsprotocolViewState();
}

class _WsprotocolViewState extends State<WsprotocolView> {
  late WsprotocolBloc protocolBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    protocolBloc = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<WsprotocolBloc, WsprotocolState>(
      listener: (context, state) async {
        if (state is WsprotocolError) {
          Dialogs().showInfoDialog(context, message: state.error);
        }
      },
      child: BlocBuilder<WsprotocolBloc, WsprotocolState>(
        builder: (context, state) {
          bool isLoading = (state is WsprotocolConnecting);
          bool connected = (state is WsprotocolConnected);
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
                        hintText: "wss://testsocket.net",
                        outerTitle: "WebSocket URL (wss/ws protocols only)",
                        controller: protocolBloc.wssTextController,
                        validator: (val) {
                          if (val != null && !Validators.isValidWebSocketUrl(val)) return 'Provide a valid socket URL';
                          return null;
                        },
                        suffixIcon: SizedBox(
                          width: size.width * 0.15,
                          child: AppButton(
                            bgColor: connected ? Colors.red : null,
                            onPressed: () {
                              if (!(_formKey.currentState?.validate() ?? false)) return;

                              if (connected) {
                                protocolBloc.add(DisconnectRequested());
                                return;
                              }
                              protocolBloc.add(ConnectRequested(
                                socketUrl: protocolBloc.wssTextController.text
                              ));
                            },
                            content: isLoading
                                ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                                : Text(connected ? "disconnect" : "Connect"),
                          ),
                        ),
                      ),
                    ),

                    // socket connection status row
                    Row(
                      spacing: 5,
                      children: [
                        Text(connected ? 'Connected' : 'Not connected'),
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
                          Row(
                            spacing: 20,
                            children: [
                              SizedBox(
                                width: size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 15,
                                  children: [
                                    AppTextField(
                                      controller: protocolBloc.randomStringController,
                                      maxLines: 5,
                                      hintText: "Send a random String to test e.g 'Hello Daniel' ",
                                    ),
                                    SizedBox(
                                      width: size.width * 0.8,
                                      child: AppButton(
                                        content: Text("Send message"),
                                        onPressed: () {
                                          protocolBloc.add(
                                            SendMessageRequested(protocolBloc.randomStringController.text),
                                          );
                                          protocolBloc.randomStringController.clear();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

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
