import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/features/dashboard/presentation/screens/dashboard_view.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  List<Widget> navigationPages = [
    DashboardView(),
    Container(),
    Container(),
  ];

  // change the tab
  void changeTabIndex(int newIndex) => emit(newIndex);
}
