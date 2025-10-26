import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/utils/app_scope.dart';
import '../../data/models/plan_item.dart';
import '../../widgets/components/hero_survey_card.dart';
import '../../widgets/components/plan_card.dart';
import '../../widgets/components/progress_radial_wheel.dart';
import '../../widgets/components/supplement_card.dart';
import '../discover/discover_screen.dart';
import '../plan/plan_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final supplementsController = AppScope.of(context).supplementsController;

    final tabs = [
      _DashboardView(onSurveyTap: () => _openSurvey(context)),
      const DiscoverScreen(),
      const PlanScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: 260.ms,
        child: tabs[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) {
          setState(() => _index = value);
          if (value == 1) {
            supplementsController.refresh();
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.house),
            label: l10n.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.compass),
            label: l10n.translate('discover'),
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.calendarCheck),
            label: l10n.translate('plan'),
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.user),
            label: l10n.translate('profile'),
          ),
        ],
      ),
    );
  }

  void _openSurvey(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.survey);
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({required this.onSurveyTap});

  final VoidCallback onSurveyTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final planController = AppScope.of(context).planController;
    final supplementsController = AppScope.of(context).supplementsController;
    final settings = AppScope.of(context).settingsController;

    return AnimatedBuilder(
      animation: Listenable.merge([planController, supplementsController, settings]),
      builder: (context, _) {
        final featuredCount = supplementsController.items.length > 4
            ? 4
            : supplementsController.items.length;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).canvasColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                title: Text(l10n.translate('app_name')),
                actions: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.moon),
                    onPressed: settings.toggleTheme,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeroSurveyCard(onContinue: onSurveyTap),
                      const SizedBox(height: 24),
                      Text(l10n.translate('your_progress'),
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProgressRadialWheel(
                            segments: planController.progressSegments,
                            progress: planController.completionRate,
                            label: l10n.translate('your_progress'),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: planController.progressSegments
                                  .map(
                                    (segment) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: segment['color'] as Color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(segment['label'] as String),
                                          const Spacer(),
                                          Text('${((segment['value'] as double) * 100).round()}%'),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(l10n.translate('today_plan'),
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      if (planController.planItems.isEmpty)
                        Text(l10n.translate('plan_empty'))
                      else
                        Column(
                          children: planController.planItems
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: PlanCard(item: item),
                                  ))
                              .toList(),
                        ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.translate('immersive_experiences'),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      _ExperienceGrid(onTap: (route) {
                        Navigator.of(context).pushNamed(route);
                      }),
                      const SizedBox(height: 24),
                      Text(l10n.translate('for_you'),
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: featuredCount,
                        itemBuilder: (context, index) {
                          final item = supplementsController.items[index];
                          return SupplementCard(
                            supplement: item,
                            onAdd: () => planController.markStatus(
                              item.id,
                              PlanStatus.pending,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExperienceGrid extends StatelessWidget {
  const _ExperienceGrid({required this.onTap});

  final void Function(String route) onTap;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ExperienceCard(
        title: AppLocalizations.of(context).translate('trainers_experience'),
        subtitle: AppLocalizations.of(context).translate('trainers_experience_desc'),
        image: 'https://images.unsplash.com/photo-1597076537063-5d0c4d8f8b74',
        route: AppRoutes.trainers,
        icon: FontAwesomeIcons.userNinja,
      ),
      _ExperienceCard(
        title: AppLocalizations.of(context).translate('store_experience'),
        subtitle: AppLocalizations.of(context).translate('store_experience_desc'),
        image: 'https://images.unsplash.com/photo-1595433707802-6b2626f3f1a4',
        route: AppRoutes.store,
        icon: FontAwesomeIcons.basketShopping,
      ),
      _ExperienceCard(
        title: AppLocalizations.of(context).translate('pass_experience'),
        subtitle: AppLocalizations.of(context).translate('pass_experience_desc'),
        image: 'https://images.unsplash.com/photo-1582719478185-ff61da3d5f3f',
        route: AppRoutes.multiClubPass,
        icon: FontAwesomeIcons.ticket,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 520;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards
              .map(
                (card) => SizedBox(
                  width: isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth,
                  child: _ExperienceCardTile(card: card, onTap: onTap),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _ExperienceCard {
  const _ExperienceCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.route,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String image;
  final String route;
  final IconData icon;
}

class _ExperienceCardTile extends StatelessWidget {
  const _ExperienceCardTile({required this.card, required this.onTap});

  final _ExperienceCard card;
  final void Function(String route) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(card.route),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface.withOpacity(0.92),
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.65),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.12)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                card.image,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.35),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: FaIcon(card.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          card.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const FaIcon(FontAwesomeIcons.arrowRightLong, color: Colors.white70),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(260.ms).moveY(begin: 12, end: 0),
    );
  }
}
