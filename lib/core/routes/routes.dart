import 'package:regex_router/regex_router.dart';
import 'package:socket_probe/core/routes/route_names.dart';
import 'package:socket_probe/features/dashboard/presentation/screens/dashboard_view.dart';
import 'package:socket_probe/features/navigation/presentation/screens/navigation_menu.dart';

class Routes {
  static final router = RegexRouter.create(
    {
      RouteNames.initialPage: (context, args) => NavigationMenu(),
      RouteNames.dashboard: (context, args) => DashboardView(),
    },
  );
}
