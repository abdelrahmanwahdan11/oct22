import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/app_scope.dart';
import '../../data/models/store_product.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeController = AppScope.of(context).storeController;
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: storeController,
      builder: (context, _) {
        final products = storeController.products;
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: Text(l10n.translate('wellness_store')),
                    actions: [
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.bagShopping),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StoreHero(),
                          const SizedBox(height: 24),
                          Text(
                            l10n.translate('curated_collections'),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (storeController.isLoading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];
                            return _ProductCard(product: product);
                          },
                          childCount: products.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
                          childAspectRatio: 0.68,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 48)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StoreHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withOpacity(0.16),
            Theme.of(context).colorScheme.primary.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1585238342028-4bbc5a00e12a',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.35),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('store_hero_title'),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.translate('store_hero_caption'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(l10n.translate('category_supplements')),
                      avatar: const FaIcon(FontAwesomeIcons.capsules, size: 14),
                    ),
                    Chip(
                      label: Text(l10n.translate('category_equipment')),
                      avatar: const FaIcon(FontAwesomeIcons.dumbbell, size: 14),
                    ),
                    Chip(
                      label: Text(l10n.translate('category_care')),
                      avatar: const FaIcon(FontAwesomeIcons.spa, size: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0);
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final StoreProduct product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: theme.colorScheme.surface.withOpacity(0.9),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: Image.network(
              product.image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.isBestSeller)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate('best_seller'),
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(product.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: product.tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('${product.price.toStringAsFixed(0)} SAR', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    const FaIcon(FontAwesomeIcons.solidStar, size: 13, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 4),
                    Text(product.rating.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context).translate('added_to_cart'))),
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.cartPlus, size: 16),
                  label: Text(AppLocalizations.of(context).translate('add_to_cart')),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 12, end: 0);
  }
}
