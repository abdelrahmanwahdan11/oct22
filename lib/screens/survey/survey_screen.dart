import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_localizations.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  double mood = 70;
  double energy = 60;
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.translate('survey'),
                    style: Theme.of(context).textTheme.headlineMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(l10n.translate('mood')),
            Slider(
              value: mood,
              min: 0,
              max: 100,
              onChanged: (value) => setState(() => mood = value),
            ),
            const SizedBox(height: 12),
            Text(l10n.translate('energy_level')),
            Slider(
              value: energy,
              min: 0,
              max: 100,
              onChanged: (value) => setState(() => energy = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.translate('notes'),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.translate('save')),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 40, end: 0);
  }
}
