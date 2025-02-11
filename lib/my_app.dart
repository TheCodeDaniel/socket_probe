import 'package:flutter/material.dart';
import 'package:socket_probe/common/widgets/unknown_route_screen.dart';
import 'package:socket_probe/core/routes/route_names.dart';
import 'package:socket_probe/core/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteNames.initialRoute,
      onGenerateRoute: (settings) => Routes.router.generateRoute(settings),
      onUnknownRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) => UnknownRouteScreen(),
      ),
    );
  }
}
