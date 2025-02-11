import 'package:flutter/material.dart';
import 'package:regex_router/regex_router.dart';
import 'package:socket_probe/core/routes/route_names.dart';

class Routes {
  static final router = RegexRouter.create(
    {
      RouteNames.initialRoute: (context, args) => Container(),
    },
  );
}
