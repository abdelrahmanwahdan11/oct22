import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/fx_commodities_controller.dart';
import 'controllers/market_controller.dart';
import 'controllers/news_controller.dart';
import 'controllers/orders_controller.dart';
import 'controllers/portfolio_controller.dart';
import 'controllers/settings_controller.dart';
import 'data/repositories/fx_commodities_repository.dart';
import 'data/repositories/market_repository.dart';
import 'data/repositories/news_repository.dart';
import 'data/repositories/orders_repository.dart';
import 'data/repositories/prefs_repository.dart';
import 'data/repositories/portfolio_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefsRepository = PrefsRepository();
  await prefsRepository.init();

  final marketRepository = MarketRepository(pageSize: 15);
  final portfolioRepository = PortfolioRepository(marketRepository, pageSize: 15);
  final fxRepository = FxCommoditiesRepository(pageSize: 15);
  final newsRepository = NewsRepository(pageSize: 15);
  final ordersRepository = OrdersRepository();

  final settingsController = SettingsController(prefsRepository);
  await settingsController.load();

  final authController = AuthController();

  final marketController = MarketController(marketRepository, prefsRepository);
  await marketController.init();

  final portfolioController =
      PortfolioController(portfolioRepository, marketRepository, prefsRepository);
  await portfolioController.init();

  final fxController = FxCommoditiesController(fxRepository);
  await fxController.init();

  final newsController = NewsController(newsRepository);
  await newsController.init();

  final ordersController = OrdersController(ordersRepository);
  await ordersController.init();

  runApp(
    TradeXApp(
      settingsController: settingsController,
      authController: authController,
      marketController: marketController,
      portfolioController: portfolioController,
      fxController: fxController,
      newsController: newsController,
      ordersController: ordersController,
      marketRepository: marketRepository,
      fxRepository: fxRepository,
    ),
  );
}
