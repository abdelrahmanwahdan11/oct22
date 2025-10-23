import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../core/design_system.dart';
import '../core/navigation.dart';
import '../l10n/app_localizations.dart';
import '../widgets/animated_entry.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final pages = _buildPages(strings);
    final isLast = _page == pages.length - 1;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF111827)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : AppGradients.background,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 720;
              final content = PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _page = value),
                itemCount: pages.length,
                itemBuilder: (context, index) => _OnboardingPage(page: pages[index], index: index),
              );

              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => _finishOnboarding(),
                          child: Text(strings.t('skip')),
                        ),
                      ],
                    ),
                    Expanded(
                      child: isWide
                          ? Row(
                              children: [
                                Expanded(child: content),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AnimatedEntry(
                                      delay: const Duration(milliseconds: 200),
                                      child: Image.asset(
                                        'assets/images/truck_side.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : content,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (index) => AnimatedContainer(
                          duration: AppMotion.base,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 10,
                          width: _page == index ? 28 : 10,
                          decoration: BoxDecoration(
                            color: _page == index
                                ? AppColors.limeDark.withOpacity(0.9)
                                : AppColors.limeSoft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLast
                            ? () => _finishOnboarding(pushLogin: true)
                            : () => _controller.nextPage(
                                  duration: AppMotion.slow,
                                  curve: AppMotion.curve,
                                ),
                        child: Text(isLast ? strings.t('get_started') : strings.t('next')),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<_OnboardingContent> _buildPages(AppLocalizations strings) {
    return [
      _OnboardingContent(
        title: strings.t('welcome_title1'),
        body: strings.t('welcome_body1'),
      ),
      _OnboardingContent(
        title: strings.t('welcome_title2'),
        body: strings.t('welcome_body2'),
      ),
      _OnboardingContent(
        title: strings.t('welcome_title3'),
        body: strings.t('welcome_body3'),
      ),
    ];
  }

  Future<void> _finishOnboarding({bool pushLogin = false}) async {
    await widget.authController.completeOnboarding();
    if (!mounted) return;
    final shouldGoToLogin = pushLogin || !widget.authController.isAuthenticated;
    Navigator.of(context).pushReplacementNamed(
      shouldGoToLogin ? AppNavigation.routes['auth.login']! : AppNavigation.routes['planning']!,
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page, required this.index});

  final _OnboardingContent page;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedEntry(
              delay: Duration(milliseconds: 120 * (index + 1)),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [AppShadows.card],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedEntry(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        page.title,
                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedEntry(
                      delay: const Duration(milliseconds: 320),
                      child: Text(
                        page.body,
                        style: theme.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({required this.title, required this.body});

  final String title;
  final String body;
}
