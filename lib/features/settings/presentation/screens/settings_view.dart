import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        width: size.width * 0.4,
        child: Column(
          spacing: 20,
          children: [
            Text(
              "Hi there, nothing here at the moment :)..... but there will be content soon enough",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
