import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/features/dashboard/bloc/dashboard_event.dart';
import 'package:socket_probe/features/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState());
}
