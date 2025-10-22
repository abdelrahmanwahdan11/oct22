import 'package:flutter/material.dart';
import 'package:smart_home_control/core/app_router.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/widgets/app_bottom_bar.dart';
import '../access/user_access_screen.dart';
import '../devices/devices_screen.dart';
import '../more/more_screen.dart';
import '../rooms/rooms_screen.dart';
import 'home_dashboard_screen.dart';

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
    final scope = ControllerScope.of(context);
    final listenable = Listenable.merge([scope.settings, scope.auth]);
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final loc = scope.auth.localization;
        final bottomItems = buildBottomItems(
          home: loc.t('nav_home'),
          devices: loc.t('nav_devices'),
          rooms: loc.t('nav_rooms'),
          more: loc.t('nav_more'),
        );
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
                MoreScreen(),
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
                  label: Text(loc.t('energy_analysis')),
                  icon: const Icon(Icons.analytics_outlined),
                )
              : null,
        );
      },
    );
  }
}
