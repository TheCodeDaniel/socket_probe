import 'package:flutter/material.dart';
import 'package:socket_probe/features/wsprotocol/presentation/screens/wsprotocol_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          SizedBox(
            width: size.width * 0.5,
            child: TabBar(
              // Customize the appearance and behavior of the tab bar

              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                color: Colors.black,
              ),
              // Add your tabs here
              tabs: const [
                Tab(text: "WS/ WSS Protocol"),
                Tab(text: "Event Sockets"),
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.85,
            height: size.height * 0.85,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                WsprotocolView(),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
