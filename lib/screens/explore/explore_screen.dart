import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/components/app_bottom_navigation.dart';
import '../../widgets/components/filter_chips.dart';
import '../../widgets/components/property_card.dart';
import '../../widgets/components/search_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  PropertiesController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = NotifierProvider.of<PropertiesController>(context);
    if (_controller != controller) {
      _controller?.scrollController.removeListener(_onScroll);
      _controller = controller;
      controller.scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.scrollController.position.pixels >
        controller.scrollController.position.maxScrollExtent - 120) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _controller?.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = NotifierProvider.of<SettingsController>(context);
    final properties = NotifierProvider.of<PropertiesController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('explore')),
      ),
      bottomNavigationBar: const AppBottomNavigation(current: 'explore'),
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: settings.isDarkMode),
        child: RefreshIndicator(
          onRefresh: properties.refresh,
          child: CustomScrollView(
            controller: properties.scrollController,
            slivers: [
              SliverToBoxAdapter(child: SearchBarWidget()),
              SliverToBoxAdapter(child: FilterChipsRow()),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () => Navigator.of(context).pushNamed('filters.sheet'),
                        icon: const FaIcon(FontAwesomeIcons.sliders, size: 16),
                        label: Text(strings.t('advanced_filters')),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.map, size: 16),
                        label: Text(strings.t('open_map')),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= properties.feed.length) {
                        return properties.loadingMore
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }
                      final property = properties.feed[index];
                      return PropertyCard(property: property, index: index);
                    },
                    childCount: properties.feed.length + (properties.loadingMore ? 1 : 0),
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}
