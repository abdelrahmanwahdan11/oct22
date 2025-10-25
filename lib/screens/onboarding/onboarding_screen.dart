import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/settings_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/controller_scope.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _pages = const [
    {
      'image': 'https://images.unsplash.com/photo-1642790116364-46db109d7d31',
      'title': 'Smart trading. Night interface. Live data.',
      'bullets': [
        'Stocks, crypto & metals',
        'Alerts & analyst ratings',
        'Easy buy & sell orders'
      ],
    },
    {
      'image': 'https://images.unsplash.com/photo-1618005198919-d3d4b5a92eee',
      'title': 'Track your positions in real time',
      'bullets': [
        'Dark & light modes',
        'Pull-to-refresh portfolios',
        'Mock data with instant feedback'
      ],
    },
    {
      'image': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
      'title': 'Send, receive & swap effortlessly',
      'bullets': [
        'Capsule actions and keypads',
        'Watchlists synced locally',
        'Bi-lingual layout with RTL'
      ],
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = context.watchController<SettingsController>();
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (value) => setState(() => _index = value),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(page['image'] as String, fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.6)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          strings.t('app_name'),
                          style: Theme.of(context).textTheme.display?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['title'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .h1
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ).animate().fadeIn(500.ms).moveY(begin: 20, end: 0),
                        const SizedBox(height: 16),
                        ...List<Widget>.from(
                          (page['bullets'] as List<String>).map(
                            (bullet) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      bullet,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: List.generate(
                            _pages.length,
                            (dot) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 6),
                              height: 8,
                              width: _index == dot ? 24 : 10,
                              decoration: BoxDecoration(
                                color: _index == dot ? Colors.white : Colors.white38,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  await settings.completeOnboarding();
                                  if (!mounted) return;
                                  Navigator.of(context).pushReplacementNamed('auth.login');
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white54),
                                ),
                                child: Text(strings.t('skip')),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FilledButton(
                                onPressed: () async {
                                  if (_index < _pages.length - 1) {
                                    _controller.animateToPage(
                                      _index + 1,
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeOut,
                                    );
                                  } else {
                                    await settings.completeOnboarding();
                                    if (!mounted) return;
                                    Navigator.of(context).pushReplacementNamed('auth.login');
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(_index < _pages.length - 1
                                    ? strings.t('continue')
                                    : strings.t('start')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
