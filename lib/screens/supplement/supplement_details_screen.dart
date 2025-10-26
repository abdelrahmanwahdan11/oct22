import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/app_scope.dart';

class SupplementDetailsScreen extends StatelessWidget {
  const SupplementDetailsScreen({super.key, required this.supplementId});

  final String? supplementId;

  @override
  Widget build(BuildContext context) {
    final supplementsRepository = AppScope.of(context).supplementsController;
    final l10n = AppLocalizations.of(context);
    final supplement = supplementId != null
        ? supplementsRepository.items.firstWhere(
              (element) => element.id == supplementId,
              orElse: () => supplementsRepository.items.first,
            )
        : supplementsRepository.items.first;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).canvasColor, Theme.of(context).scaffoldBackgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(supplement.name),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'supp_${supplement.id}',
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: Image.network(
                          supplement.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supplement.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.translate('benefits'),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          ...supplement.benefits.map(
                            (benefit) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.sparkles, size: 14),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(benefit)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('${l10n.translate('dosage')}: ${supplement.dosage}'),
                          const SizedBox(height: 8),
                          Text('${l10n.translate('schedule')}: ${supplement.schedule}'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.star, color: Colors.amber),
                              const SizedBox(width: 6),
                              Text('${supplement.rating}')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
