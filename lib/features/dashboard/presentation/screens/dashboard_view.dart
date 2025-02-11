import 'package:flutter/material.dart';
import 'package:socket_probe/common/utils/validators.dart';
import 'package:socket_probe/common/widgets/app_button.dart';
import 'package:socket_probe/common/widgets/app_textfield.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
                  outerTitle: "WebSocket URL",
                  controller: null,
                  validator: (val) {
                    if (val != null && !Validators.isValidWebSocketUrl(val)) return 'Provide a valid socket URL';
                    return null;
                  },
                  suffixIcon: SizedBox(
                    width: size.width * 0.1,
                    child: AppButton(
                      onPressed: () {
                        if (!(_formKey.currentState?.validate() ?? false)) return;
                      },
                      content: Text("Connect"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
