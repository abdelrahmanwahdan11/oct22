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
