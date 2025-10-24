import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/animations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  int _index = 0;

  final _pages = const [
    _OnboardingPage(
      image: 'https://images.unsplash.com/photo-1501183638710-841dd1904471',
      titleKey: 'onboarding_title',
      subtitleKey: 'onboarding_subtitle',
    ),
    _OnboardingPage(
      image: 'https://images.unsplash.com/photo-1494526585095-c41746248156',
      titleKey: 'summary',
      subtitleKey: 'market',
    ),
    _OnboardingPage(
      image: 'https://images.unsplash.com/photo-1505691938895-1758d7feb511',
      titleKey: 'explore',
      subtitleKey: 'search_hint',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  Future<void> _complete() async {
    final settings = NotifierProvider.read<SettingsController>(context);
    await settings.completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('auth.login');
  }

  @override
  Widget build(BuildContext context) {
    final settings = NotifierProvider.of<SettingsController>(context);
    final strings = AppLocalizations.of(context);
    final isDark = settings.isDarkMode;
    return Scaffold(
      body: Container(
        decoration: AppDecorations.gradientBackground(dark: isDark),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.network(page.image, fit: BoxFit.cover),
                            ).fadeMove(),
                          ),
                        ),
                        Text(
                          strings.t(page.titleKey),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ).fadeMove(delay: 100),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            strings.t(page.subtitleKey),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color
                                      ?.withOpacity(0.7),
                                ),
                            textAlign: TextAlign.center,
                          ).fadeMove(delay: 150),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              height: 6,
                              width: _index == i ? 24 : 10,
                              decoration: BoxDecoration(
                                color: _index == i
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: _complete,
                      child: Text(strings.t('skip')),
                    ),
                    const Spacer(),
                    if (_index < _pages.length - 1)
                      FilledButton.icon(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOut,
                          );
                        },
                        icon: const FaIcon(FontAwesomeIcons.arrowRight, size: 16),
                        label: Text(strings.t('next')),
                      )
                    else
                      FilledButton(
                        onPressed: _complete,
                        child: Text(strings.t('start')),
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

class _OnboardingPage {
  const _OnboardingPage({
    required this.image,
    required this.titleKey,
    required this.subtitleKey,
  });

  final String image;
  final String titleKey;
  final String subtitleKey;
}
