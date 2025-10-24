import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/animations.dart';
import '../../widgets/components/app_bottom_navigation.dart';
import '../../widgets/components/pill_tabs.dart';
import '../../widgets/components/promo_info_card.dart';
import '../../widgets/components/property_card.dart';
import '../../widgets/components/search_bar.dart';
import '../../widgets/components/filter_chips.dart';
import '../../widgets/components/stat_pill.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: Text(strings.t('app_name')),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.gear, size: 18),
            onPressed: () => Navigator.of(context).pushNamed('settings'),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell, size: 18),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(current: 'home'),
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: settings.isDarkMode),
        child: RefreshIndicator(
          onRefresh: properties.refresh,
          child: CustomScrollView(
            controller: properties.scrollController,
            slivers: [
              SliverToBoxAdapter(child: SearchBarWidget()),
              SliverToBoxAdapter(child: FilterChipsRow()),
              SliverToBoxAdapter(child: PillTabs(onChanged: (_) {})),
              SliverToBoxAdapter(
                child: StatPill(
                  label: strings.t('market'),
                  value: '3.4%',
                  trend: 1.4,
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 12)),
              SliverToBoxAdapter(child: PromoInfoCard()),
              SliverToBoxAdapter(child: const SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        strings.t('see_all'),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(strings.t('see_all')),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 260,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => PropertyCard(
                      property: properties.featured[index],
                      index: index,
                    ),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: properties.featured.length,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    strings.t('suggested_list'),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ).fadeMove(),
                ),
              ),
              if (properties.loading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= properties.feed.length) {
                        return properties.loadingMore
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }
                      final property = properties.feed[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: PropertyCard(property: property, index: index),
                      );
                    },
                    childCount: properties.feed.length + 1,
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
