import 'package:flutter/material.dart';

class TopTabItem {
  const TopTabItem(this.label);
  final String label;
}

class ToolbarItem {
  const ToolbarItem({required this.id, required this.icon});

  final String id;
  final IconData icon;
}

class AppNavigation {
  static const topTabs = [
    TopTabItem('Planning'),
    TopTabItem('Distribution'),
    TopTabItem('Statistics'),
  ];

  static const toolbarItems = [
    ToolbarItem(id: 'stops', icon: Icons.list_alt),
    ToolbarItem(id: 'boxes', icon: Icons.view_module),
    ToolbarItem(id: 'route', icon: Icons.route),
    ToolbarItem(id: 'optimizer', icon: Icons.bolt),
  ];

  static const routes = {
    'onboarding': '/onboarding',
    'auth.login': '/auth/login',
    'auth.register': '/auth/register',
    'planning': '/planning',
    'distribution': '/distribution',
    'statistics': '/statistics',
    'timeline.cockpit': '/timeline.cockpit',
    'map.optimization': '/map.optimization',
    'settings': '/settings',
  };
}
