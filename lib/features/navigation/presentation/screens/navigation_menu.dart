import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socket_probe/features/navigation/bloc/navigation_cubit.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  minWidth: size.width * 0.01,
                  labelType: NavigationRailLabelType.all,
                  elevation: 5,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Iconsax.home),
                      label: Text("Dashboard"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Iconsax.setting),
                      label: Text("Settings"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Iconsax.message_question),
                      label: Text("Enquire"),
                    ),
                  ],
                  selectedIndex: state,
                  onDestinationSelected: (value) => context.read<NavigationCubit>().changeTabIndex(value),
                ),
                Expanded(
                  child: IndexedStack(
                    index: state,
                    children: context.read<NavigationCubit>().navigationPages,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
