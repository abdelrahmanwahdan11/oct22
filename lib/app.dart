import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/auth_controller.dart';
import 'controllers/fx_commodities_controller.dart';
import 'controllers/market_controller.dart';
import 'controllers/news_controller.dart';
import 'controllers/orders_controller.dart';
import 'controllers/portfolio_controller.dart';
import 'controllers/settings_controller.dart';
import 'core/localization/app_localizations.dart';
import 'core/providers/notifier_provider.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/fx_commodities_repository.dart';
import 'data/repositories/market_repository.dart';

class TradeXApp extends StatefulWidget {
  const TradeXApp({
    super.key,
    required this.settingsController,
    required this.authController,
    required this.marketController,
    required this.portfolioController,
    required this.fxController,
    required this.newsController,
    required this.ordersController,
    required this.marketRepository,
    required this.fxRepository,
  });

  final SettingsController settingsController;
  final AuthController authController;
  final MarketController marketController;
  final PortfolioController portfolioController;
  final FxCommoditiesController fxController;
  final NewsController newsController;
  final OrdersController ordersController;
  final MarketRepository marketRepository;
  final FxCommoditiesRepository fxRepository;

  @override
  State<TradeXApp> createState() => _TradeXAppState();
}

class _TradeXAppState extends State<TradeXApp> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter();
  }

  @override
  void dispose() {
    widget.settingsController.dispose();
    widget.authController.dispose();
    widget.marketController.dispose();
    widget.portfolioController.dispose();
    widget.fxController.dispose();
    widget.newsController.dispose();
    widget.ordersController.dispose();
    unawaited(widget.marketRepository.dispose());
    widget.fxRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotifierProvider<SettingsController>(
      notifier: widget.settingsController,
      child: NotifierProvider<AuthController>(
        notifier: widget.authController,
        child: NotifierProvider<MarketController>(
          notifier: widget.marketController,
          child: NotifierProvider<PortfolioController>(
            notifier: widget.portfolioController,
            child: NotifierProvider<FxCommoditiesController>(
              notifier: widget.fxController,
              child: NotifierProvider<NewsController>(
                notifier: widget.newsController,
                child: NotifierProvider<OrdersController>(
                  notifier: widget.ordersController,
                  child: Builder(
                    builder: (context) {
                      final settings = NotifierProvider.of<SettingsController>(context);
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'TradeX',
                        theme: TradeXTheme.light(),
                        darkTheme: TradeXTheme.dark(),
                        themeMode: settings.themeMode,
                        locale: settings.locale,
                        supportedLocales: AppLocalizations.supportedLocales,
                        localizationsDelegates: const [
                          AppLocalizationsDelegate(),
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        localeResolutionCallback: (locale, supported) {
                          if (locale == null) return AppLocalizations.defaultLocale;
                          for (final supportedLocale in supported) {
                            if (supportedLocale.languageCode == locale.languageCode) {
                              return supportedLocale;
                            }
                          }
                          return AppLocalizations.defaultLocale;
                        },
                        initialRoute:
                            settings.onboardingComplete ? 'auth.login' : 'onboarding',
                        onGenerateRoute: _router.onGenerateRoute,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
