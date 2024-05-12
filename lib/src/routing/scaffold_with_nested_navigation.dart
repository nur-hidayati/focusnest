import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.width < 450) {
      return ScaffoldWithNavigationBar(
        body: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    } else {
      return ScaffoldWithNavigationRail(
        body: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    }
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 0.5,
              blurRadius: 2,
            ),
          ],
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.grey.shade50,
          indicatorColor: Colors.transparent,
          selectedIndex: currentIndex,
          destinations: bottomNavBarItems.map((item) {
            return NavigationDestination(
              icon: Icon(
                item.icon,
                color: AppColor.greyColor,
              ),
              selectedIcon: Icon(
                item.selectedIcon,
                color: AppColor.primaryColor,
              ),
              label: item.title,
            );
          }).toList(),
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: bottomNavBarItems.map((item) {
              return NavigationRailDestination(
                icon: Icon(
                  item.icon,
                  color: AppColor.greyColor,
                ),
                selectedIcon: Icon(
                  item.selectedIcon,
                  color: AppColor.primaryColor,
                ),
                label: Text(item.title),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}

final List<BottomNavBarItems> bottomNavBarItems = [
  BottomNavBarItems(
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_today,
    title: 'Calendar',
  ),
  BottomNavBarItems(
    icon: Icons.timer_outlined,
    selectedIcon: Icons.timer,
    title: 'Timer',
  ),
  BottomNavBarItems(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    title: 'Settings',
  ),
];

class BottomNavBarItems {
  final IconData icon;
  final IconData selectedIcon;
  final String title;

  BottomNavBarItems({
    required this.icon,
    required this.selectedIcon,
    required this.title,
  });
}
