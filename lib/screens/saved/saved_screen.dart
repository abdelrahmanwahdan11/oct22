import 'package:flutter/material.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/components/app_bottom_navigation.dart';
import '../../widgets/components/property_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final favorites = NotifierProvider.of<FavoritesController>(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    final items = favorites.favoritesList();
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('saved')),
      ),
      bottomNavigationBar: const AppBottomNavigation(current: 'saved'),
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: settings.isDarkMode),
        child: items.isEmpty
            ? Center(
                child: Text(strings.t('empty_saved')),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) => PropertyCard(
                  property: items[index],
                  index: index,
                ),
                itemCount: items.length,
              ),
      ),
    );
  }
}
