import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/app_scope.dart';
import '../../widgets/components/plan_card.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final planController = AppScope.of(context).planController;
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: planController,
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
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate('today_plan'),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: planController.planItems.isEmpty
                        ? Center(child: Text(l10n.translate('plan_empty')))
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = planController.planItems[index];
                              return PlanCard(item: item);
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 14),
                            itemCount: planController.planItems.length,
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
