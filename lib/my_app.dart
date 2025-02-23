import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/common/themes/app_theme.dart';
import 'package:socket_probe/common/widgets/unknown_route_screen.dart';
import 'package:socket_probe/core/routes/route_names.dart';
import 'package:socket_probe/core/routes/routes.dart';
import 'package:socket_probe/features/event_sockets/bloc/event_sockets_bloc.dart';
import 'package:socket_probe/features/navigation/bloc/navigation_cubit.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      doWhenWindowReady(() {
        final win = appWindow;
        win.minSize = const Size(1024, 768);
        win.size = const Size(1024, 768);
        win.alignment = Alignment.center;
        win.show();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => WsprotocolBloc(),
        ),
        BlocProvider(
          create: (context) => EventSocketsBloc(),
        ),
      ],
      child: MaterialApp(
        initialRoute: RouteNames.initialPage,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        onGenerateRoute: (settings) => Routes.router.generateRoute(settings),
        onUnknownRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => UnknownRouteScreen(),
        ),
      ),
    );
  }
}
