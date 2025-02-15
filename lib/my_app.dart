import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/common/themes/app_theme.dart';
import 'package:socket_probe/common/widgets/unknown_route_screen.dart';
import 'package:socket_probe/core/routes/route_names.dart';
import 'package:socket_probe/core/routes/routes.dart';
import 'package:socket_probe/features/event_sockets/bloc/event_sockets_bloc.dart';
import 'package:socket_probe/features/navigation/bloc/navigation_cubit.dart';
import 'package:socket_probe/features/wsprotocol/bloc/wsprotocol_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
