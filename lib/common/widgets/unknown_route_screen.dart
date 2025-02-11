import 'package:flutter/material.dart';

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page Not Found", style: TextStyle(color: Colors.black)),
      ),
      body: const Center(
        child: Text("Sorry, could not find this page"),
      ),
    );
  }
}
