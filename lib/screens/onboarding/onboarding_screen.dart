import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/auth_controller.dart';
import 'package:smart_home_control/core/app_localizations.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final auth = scope.auth;
    final loc = auth.localization;
    final slides = _buildSlides(loc);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: TextButton(
                  onPressed: () => auth.completeOnboarding(),
                  child: Text(loc.t('skip')),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _index = value),
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadii.xl),
                              gradient: const LinearGradient(
                                colors: AppGradients.blueGlass,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      slide.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          slide.title,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _DotsIndicator(count: slides.length, index: _index),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_index == slides.length - 1) {
                      auth.completeOnboarding();
                    } else {
                      _pageController.nextPage(duration: AppMotion.base, curve: AppMotion.curve);
                    }
                  },
                  child: Text(_index == slides.length - 1 ? loc.t('get_started') : loc.t('next')),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<_OnboardingSlide> _buildSlides(AppLocalizations localization) {
    return [
      _OnboardingSlide(
        title: localization.t('onboarding_title_1'),
        subtitle: localization.t('onboarding_desc_1'),
        image: 'assets/images/room_living.jpg',
      ),
      _OnboardingSlide(
        title: localization.t('onboarding_title_2'),
        subtitle: localization.t('onboarding_desc_2'),
        image: 'assets/images/device_camera.png',
      ),
      _OnboardingSlide(
        title: localization.t('onboarding_title_3'),
        subtitle: localization.t('onboarding_desc_3'),
        image: 'assets/images/device_ac.png',
      ),
    ];
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String image;
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: AppMotion.base,
            curve: AppMotion.curve,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == index ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
      ],
    );
  }
}
