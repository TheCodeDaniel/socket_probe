import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:json_editor/json_editor.dart';
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

  final paramScrollController = ScrollController();

  @override
  void initState() {
    socketBloc = context.read();
    super.initState();
  }

  Map<String, dynamic> defaultParamListString = {
    "auth": {"token": "userToken"},
    "transports": ["websocket"],
    "autoConnect": true,
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
                        validator: connected
                            ? null
                            : (val) {
                                if (val != null && !Validators.isValidHttpUrl(val)) {
                                  return 'Provide a valid/supported URL';
                                }

                                return null;
                              },
                        suffixIcon: SizedBox(
                          width: size.width * 0.15,
                          child: AppButton(
                            bgColor: connected ? Colors.red : Colors.green,
                            onPressed: () {
                              if (!connected) {
                                if (!(_formKey.currentState?.validate() ?? false)) return;
                              }

                              if (connected) {
                                socketBloc.add(DisconnectRequested());
                                return;
                              }
                              socketBloc.add(ConnectRequested(
                                socketUrl: socketBloc.socketTextController.text,
                                sockedConfigurations: defaultParamListString,
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

                    // socket params
                    if (!connected)
                      Row(
                        spacing: 10,
                        children: [
                          Icon(Iconsax.warning_2, color: Colors.amber),
                          Text(
                            "Check your socket parameters before connecting to websocket",
                            style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    Container(
                      width: size.width * 0.4,
                      height: size.height * 0.2,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.grey.shade200,
                      child: JsonEditorTheme(
                        themeData: JsonEditorThemeData(lightTheme: JsonTheme.light()),
                        child: JsonEditor.object(
                          enabled: !connected,
                          object: defaultParamListString,
                          onValueChanged: (JsonElement value) {
                            String prettyString = value.toPrettyString();
                            Map<String, dynamic> formattedPretty = json.decode(prettyString);
                            Map<String, dynamic> convertedFormat = Map<String, dynamic>.from(formattedPretty);
                            // Sanitize before updating state
                            convertedFormat = sanitizeJson(convertedFormat);

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                defaultParamListString = convertedFormat;
                              });
                            });
                          },
                        ),
                      ),
                    ),

                    // input fields section
                    if (connected)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          // textfield row
                          SizedBox(
                            width: size.width * 0.25,
                            child: AppTextField(
                              required: true,
                              controller: socketBloc.eventTextController,
                              outerTitle: "Event name (emit)",
                              hintText: "Examples: connect, disconnect, messages.new, payment_status",
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please provide an event name";
                                }
                                return null;
                              },
                            ),
                          ),

                          // message box
                          SizedBox(
                            width: size.width * 0.45,
                            child: AppTextField(
                              maxLines: 2,
                              required: true,
                              controller: socketBloc.messageTextController,
                              outerTitle: "Message",
                              hintText: "Send your websocket message here",
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please attach a message";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.1,
                            child: AppButton(
                              onPressed: () {
                                if (!(_formKey.currentState?.validate() ?? false)) return;
                                socketBloc.add(SendMessageRequested(
                                  message: socketBloc.messageTextController.text,
                                  event: socketBloc.eventTextController.text,
                                ));
                              },
                              content: Text("Send"),
                            ),
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

  Map<String, dynamic> sanitizeJson(Map<String, dynamic> input) {
    input.forEach((key, value) {
      if (value is List) {
        // Convert List<dynamic> to List<String>
        input[key] = value.map((e) => e.toString()).toList();
      } else if (value is Map<String, dynamic>) {
        // Recursively clean nested maps
        input[key] = sanitizeJson(value);
      }
    });
    return input;
  }
}
