import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/app_scope.dart';
import '../../widgets/components/chip_tabs.dart';
import '../../widgets/components/search_bar.dart';
import '../../widgets/components/supplement_card.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final controller = AppScope.of(context).supplementsController;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final supplementsController = AppScope.of(context).supplementsController;

    return AnimatedBuilder(
      animation: supplementsController,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).canvasColor, Theme.of(context).scaffoldBackgroundColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: supplementsController.refresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.translate('discover'),
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(l10n.translate('filters')),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AnimatedSearchBar(
                            onChanged: supplementsController.search,
                            onFilters: () {},
                          ),
                          const SizedBox(height: 18),
                          ChipTabs(
                            tabs: const ['energy', 'heart', 'stress'],
                            selectedTabs: supplementsController.selectedTabs,
                            onTap: (value) => supplementsController.toggleTag(value),
                            labelBuilder: (value) => l10n.translate(value),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= supplementsController.items.length) {
                            return const SizedBox.shrink();
                          }
                          final item = supplementsController.items[index];
                          return SupplementCard(
                            supplement: item,
                            onAdd: () {},
                          );
                        },
                        childCount: supplementsController.items.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: supplementsController.isLoading
                            ? const CircularProgressIndicator()
                            : supplementsController.hasMore
                                ? Text(l10n.translate('loading'))
                                : Text(l10n.translate('essentials')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
