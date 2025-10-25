import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';

class TradeXBottomNav extends StatelessWidget {
  const TradeXBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  void _onTap(BuildContext context, int index) {
    const routes = [
      'portfolio.home',
      'market.browse',
      'watchlist',
      'news.center',
      'account',
    ];
    if (index == currentIndex) return;
    Navigator.of(context).pushReplacementNamed(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      items: [
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.wallet),
          label: strings.t('portfolio'),
        ),
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.chartLine),
          label: strings.t('market'),
        ),
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.star),
          label: strings.t('watchlist'),
        ),
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.newspaper),
          label: strings.t('news'),
        ),
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.user),
          label: strings.t('account'),
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
