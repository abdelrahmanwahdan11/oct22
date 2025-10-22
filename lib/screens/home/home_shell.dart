import 'package:flutter/material.dart';
import 'package:smart_home_control/core/app_router.dart';
import 'package:smart_home_control/widgets/app_bottom_bar.dart';
import 'home_dashboard_screen.dart';
import '../devices/devices_screen.dart';
import '../rooms/rooms_screen.dart';
import '../access/user_access_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final _pageController = PageController();
  int _index = 0;

  final _storageBucket = PageStorageBucket();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavChange(int index) {
    setState(() => _index = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final bottomItems = buildBottomItems(Theme.of(context).textTheme);
    return Scaffold(
      body: PageStorage(
        bucket: _storageBucket,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeDashboardScreen(),
            DevicesScreen(),
            RoomsScreen(),
            UserAccessScreen(),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: _index,
        onChanged: _onNavChange,
        items: bottomItems,
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.monthlyAnalysis);
              },
              label: const Text('Energy Analysis'),
              icon: const Icon(Icons.analytics_outlined),
            )
          : null,
    );
  }
}
