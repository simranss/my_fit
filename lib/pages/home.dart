import 'package:flutter/material.dart';
import 'package:my_fit/models/home.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeModel = context.read<HomeModel>();
    return SafeArea(
      child: Scaffold(
        body: Selector<HomeModel, int>(
          selector: (_, model) => model.currentIndex,
          builder: (_, index, __) => homeModel.screens[index],
        ),
        bottomNavigationBar: Selector<HomeModel, int>(
          builder: (_, index, __) => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
                tooltip: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: 'Settings',
                tooltip: 'Settings',
              ),
            ],
          ),
          selector: (_, model) => model.currentIndex,
        ),
      ),
    );
  }
}
