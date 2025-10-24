import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.current,
  });

  final String current;

  static const _items = [
    _NavItem('home', FontAwesomeIcons.house, 'home'),
    _NavItem('explore', FontAwesomeIcons.magnifyingGlass, 'explore'),
    _NavItem('saved', FontAwesomeIcons.heart, 'saved'),
    _NavItem('account', FontAwesomeIcons.user, 'account'),
  ];

  void _onTap(BuildContext context, String id) {
    if (id == current) return;
    switch (id) {
      case 'home':
        Navigator.of(context).pushReplacementNamed('home');
        break;
      case 'explore':
        Navigator.of(context).pushReplacementNamed('explore');
        break;
      case 'saved':
        Navigator.of(context).pushReplacementNamed('saved');
        break;
      case 'account':
        Navigator.of(context).pushReplacementNamed('account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      child: BottomNavigationBar(
        currentIndex: _items.indexWhere((element) => element.id == current),
        onTap: (index) => _onTap(context, _items[index].id),
        items: _items
            .map(
              (item) => BottomNavigationBarItem(
                icon: FaIcon(item.icon),
                label: strings.t(item.labelKey),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.id, this.icon, this.labelKey);

  final String id;
  final IconData icon;
  final String labelKey;
}
