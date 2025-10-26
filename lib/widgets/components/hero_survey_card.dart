import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class HeroSurveyCard extends StatefulWidget {
  const HeroSurveyCard({
    super.key,
    required this.onContinue,
  });

  final VoidCallback onContinue;

  @override
  State<HeroSurveyCard> createState() => _HeroSurveyCardState();
}

class _HeroSurveyCardState extends State<HeroSurveyCard> {
  double _mood = 50;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Stack(
        children: [
          SizedBox(
            height: 260,
            width: double.infinity,
            child: Image.network(
              'https://images.unsplash.com/photo-1585238342028-4bbc5a00e12a',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: AppGradients.hero,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate('survey_q'),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ).animate().fadeIn(260.ms).moveY(begin: 16, end: 0),
                  const Spacer(),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.faceSadTear,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                          ),
                          child: Slider(
                            value: _mood,
                            min: 0,
                            max: 100,
                            onChanged: (value) {
                              setState(() => _mood = value);
                            },
                          ),
                        ),
                      ),
                      const FaIcon(
                        FontAwesomeIcons.faceLaughBeam,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: widget.onContinue,
                    child: Text(l10n.translate('continue')),
                  ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0);
  }
}
