import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/common/utils/dialogs.dart';
import 'package:socket_probe/common/utils/validators.dart';
import 'package:socket_probe/common/widgets/app_button.dart';
import 'package:socket_probe/common/widgets/app_textfield.dart';
import 'package:socket_probe/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:socket_probe/features/dashboard/bloc/dashboard_event.dart';
import 'package:socket_probe/features/dashboard/bloc/dashboard_state.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late DashboardBloc dashboardBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    dashboardBloc = context.read();
    dashboardBloc.wssTextController = TextEditingController();
    dashboardBloc.randomStringController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) async {
        if (state is DashboardError) {
          Dialogs().showInfoDialog(context, message: state.error);
        }
      },
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          bool isLoading = (state is DashboardConnecting);
          bool connected = (state is DashboardConnected);
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
                        controller: dashboardBloc.wssTextController,
                        validator: (val) {
                          if (val != null && !Validators.isValidWebSocketUrl(val)) return 'Provide a valid socket URL';
                          return null;
                        },
                        suffixIcon: SizedBox(
                          width: size.width * 0.15,
                          child: AppButton(
                            onPressed: () {
                              if (!(_formKey.currentState?.validate() ?? false)) return;

                              if (connected) {
                                dashboardBloc.add(DisconnectRequested());
                                return;
                              }
                              dashboardBloc.add(ConnectRequested());
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
                                      controller: dashboardBloc.randomStringController,
                                      maxLines: 5,
                                      hintText: "Send a random String to test e.g 'Hello Daniel' ",
                                    ),
                                    SizedBox(
                                      width: size.width * 0.8,
                                      child: AppButton(
                                        content: Text("Send message"),
                                        onPressed: () {
                                          dashboardBloc.add(
                                            SendMessageRequested(dashboardBloc.randomStringController.text),
                                          );
                                          dashboardBloc.randomStringController.clear();
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
