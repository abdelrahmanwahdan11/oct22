import 'package:flutter/material.dart';
import 'package:smart_home_control/screens/access/user_access_screen.dart';
import 'package:smart_home_control/screens/analysis/monthly_analysis_screen.dart';
import 'package:smart_home_control/screens/device_detail/climate_screen.dart';
import 'package:smart_home_control/screens/device_detail/light_screen.dart';
import 'package:smart_home_control/screens/device_detail/security_camera_screen.dart';
import 'package:smart_home_control/screens/devices/devices_screen.dart';
import 'package:smart_home_control/screens/home/home_dashboard_screen.dart';
import 'package:smart_home_control/screens/rooms/rooms_screen.dart';

class AppRoutes {
  static const home = 'home.dashboard';
  static const rooms = 'rooms.list';
  static const devices = 'devices.list';
  static const deviceClimate = 'device.climate';
  static const deviceCamera = 'device.camera';
  static const deviceLight = 'device.light';
  static const userAccess = 'user.access';
  static const monthlyAnalysis = 'analysis.monthly';
}

typedef RouteBuilder = Widget Function(BuildContext context, dynamic args);

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.home:
        return _fadeSlide(const HomeDashboardScreen(), settings);
      case AppRoutes.rooms:
        return _fadeSlide(const RoomsScreen(), settings);
      case AppRoutes.devices:
        return _fadeSlide(const DevicesScreen(), settings);
      case AppRoutes.deviceClimate:
        return _fadeSlide(ClimateControlScreen(deviceId: args as String?), settings);
      case AppRoutes.deviceCamera:
        return _fadeSlide(SecurityCameraScreen(deviceId: args as String?), settings);
      case AppRoutes.deviceLight:
        return _fadeSlide(LightControlScreen(deviceId: args as String?), settings);
      case AppRoutes.userAccess:
        return _fadeSlide(const UserAccessScreen(), settings);
      case AppRoutes.monthlyAnalysis:
        return _fadeSlide(const MonthlyAnalysisScreen(), settings);
    }
    return null;
  }

  static PageRouteBuilder<dynamic> _fadeSlide(Widget page, RouteSettings settings) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final slideTween = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: animation.drive(slideTween), child: child),
        );
      },
    );
  }
}
