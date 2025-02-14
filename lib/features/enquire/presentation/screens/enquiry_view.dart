import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EnquiryView extends StatelessWidget {
  const EnquiryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            "Welcome to Socket Probe 🔌",
            style: TextStyle(fontSize: 30),
          ),
          Text(
            "Using socket probe can help you easily test your websocket connect, it does not matter the kind of developer you are",
            style: TextStyle(fontSize: 18),
          ),
          Row(
            spacing: 10,
            children: [
              Text(
                "Please support this project by just dropping",
                style: TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse("https://github.com/TheCodeDaniel/socket_probe")),
                  child: Text("⭐️ Star on github"))
            ],
          ),
          SizedBox(height: 30),
          Text(
            "Have a Bug or feature request ?",
            style: TextStyle(fontSize: 20),
          ),
          Row(
            spacing: 10,
            children: [
              Text(
                "Experienced a bug or you want to drop your suggestion ?",
                style: TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse("https://github.com/TheCodeDaniel/socket_probe/issues")),
                  child: Text("💻 Github repo"))
            ],
          ),
        ],
      ),
    );
  }
}
