import 'package:flutter/material.dart';

import '../../screens/account/account_screen.dart';
import '../../screens/asset/asset_details_screen.dart';
import '../../screens/asset/order_sheet.dart';
import '../../screens/auth/forgot_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/filters/filters_sheet.dart';
import '../../screens/knowledge/ai_insights_screen.dart';
import '../../screens/market/market_browse_screen.dart';
import '../../screens/market/prices_fxmetals_screen.dart';
import '../../screens/market/search_screen.dart';
import '../../screens/market/asset_comparison_screen.dart';
import '../../screens/feature/feature_experience_screen.dart';
import '../../screens/news/news_center_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/portfolio/portfolio_home_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/transfer/transfer_exchange_screen.dart';
import '../../screens/transfer/transfer_receive_screen.dart';
import '../../screens/transfer/transfer_send_screen.dart';
import '../../screens/watchlist/watchlist_screen.dart';

class AppRouter {
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name;
    switch (name) {
      case '/':
      case 'onboarding':
        return _default(settings, const OnboardingScreen());
      case 'auth.login':
        return _default(settings, const LoginScreen());
      case 'auth.register':
        return _default(settings, const RegisterScreen());
      case 'auth.forgot':
        return _default(settings, const ForgotPasswordScreen());
      case 'portfolio.home':
        return _default(settings, const PortfolioHomeScreen());
      case 'market.browse':
        return _default(settings, const MarketBrowseScreen());
      case 'asset.compare':
        return _default(settings, const AssetComparisonScreen());
      case 'prices.fxmetals':
        return _default(settings, const PricesFxMetalsScreen());
      case 'asset.details':
        final id = settings.arguments as String?;
        if (id == null) return null;
        return _default(settings, AssetDetailsScreen(assetId: id));
      case 'order.sheet':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) return null;
        return _modal(settings, OrderSheet(
          assetId: args['assetId'] as String,
          initialSide: (args['side'] as String?) ?? 'buy',
        ));
      case 'transfer.send':
        return _default(settings, const TransferSendScreen());
      case 'transfer.receive':
        return _default(settings, const TransferReceiveScreen());
      case 'transfer.exchange':
        return _default(settings, const TransferExchangeScreen());
      case 'watchlist':
        return _default(settings, const WatchlistScreen());
      case 'news.center':
        return _default(settings, const NewsCenterScreen());
      case 'search':
        return _default(settings, const MarketSearchScreen());
      case 'filters.sheet':
        return _modal(settings, const FiltersSheet());
      case 'account':
        return _default(settings, const AccountScreen());
      case 'settings':
        return _default(settings, const SettingsScreen());
      case 'ai.hub':
        return _default(settings, const AiInsightsScreen());
      case 'feature.experience':
        final args = settings.arguments as FeatureExperienceArgs?;
        if (args == null) return null;
        return _default(settings, FeatureExperienceScreen(args: args));
      default:
        return null;
    }
  }

  PageRoute<dynamic> _default(RouteSettings settings, Widget child) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 0.06), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: animation.drive(tween), child: child),
        );
      },
    );
  }

  PageRoute<dynamic> _modal(RouteSettings settings, Widget child) {
    return PageRouteBuilder(
      settings: settings,
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.1), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOut))
                .animate(animation),
            child: child,
          ),
        );
      },
    );
  }
}
