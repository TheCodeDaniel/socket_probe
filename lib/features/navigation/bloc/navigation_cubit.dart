import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_probe/features/dashboard/presentation/screens/dashboard_view.dart';
import 'package:socket_probe/features/enquire/presentation/screens/enquiry_view.dart';
import 'package:socket_probe/features/settings/presentation/screens/settings_view.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  List<Widget> navigationPages = [
    DashboardView(),
    SettingsView(),
    EnquiryView(),
  ];

  // change the tab
  void changeTabIndex(int newIndex) => emit(newIndex);
}
