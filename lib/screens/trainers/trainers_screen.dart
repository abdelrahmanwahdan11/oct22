import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/utils/app_scope.dart';
import '../../data/models/fitness_club.dart';
import '../../data/models/trainer.dart';

class TrainersScreen extends StatelessWidget {
  const TrainersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final trainerController = scope.trainerController;
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: trainerController,
      builder: (context, _) {
        final trainers = trainerController.trainers;
        final clubs = trainerController.clubs;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: Text(l10n.translate('elite_trainers')),
                    actions: [
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.idBadge),
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.trainerRegistration);
                        },
                        tooltip: l10n.translate('register_as_trainer'),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeroCard(),
                          const SizedBox(height: 24),
                          Text(
                            l10n.translate('featured_trainers'),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          if (trainerController.isLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            Column(
                              children: trainers
                                  .map(
                                    (trainer) => Padding(
                                      padding: const EdgeInsets.only(bottom: 18),
                                      child: _TrainerTile(trainer: trainer),
                                    ),
                                  )
                                  .toList(),
                            ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRoutes.trainerRegistration);
                            },
                            icon: const FaIcon(FontAwesomeIcons.penToSquare),
                            label: Text(l10n.translate('become_trainer_cta')),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            l10n.translate('partner_clubs'),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          Column(
                            children: clubs
                                .map(
                                  (club) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _ClubCard(club: club),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 32),
                          _PassTeaser(onViewPass: () {
                            Navigator.of(context).pushNamed(AppRoutes.multiClubPass);
                          }),
                          const SizedBox(height: 48),
                        ],
                      ),
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

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.18),
            Theme.of(context).colorScheme.secondary.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1597076537063-5d0c4d8f8b74',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.28),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('train_with_champions'),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.translate('trainers_intro'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.88),
                      ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.multiClubPass);
                  },
                  child: Text(l10n.translate('view_pass')),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0);
  }
}

class _TrainerTile extends StatelessWidget {
  const _TrainerTile({required this.trainer});

  final TrainerProfile trainer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: theme.colorScheme.surface.withOpacity(0.86),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    trainer.avatar,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.name,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trainer.specialty,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.solidStar, size: 14, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 4),
                          Text('${trainer.rating.toStringAsFixed(1)}'),
                          const SizedBox(width: 12),
                          FaIcon(FontAwesomeIcons.language, size: 13, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              trainer.languages.join(' • '),
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(trainer.bio, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: trainer.sessionTypes
                  .map(
                    (type) => Chip(
                      label: Text(type),
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Text(l10n.translate('next_availability'), style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            ...trainer.nextAvailability
                .map((slot) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.clock, size: 13),
                          const SizedBox(width: 8),
                          Expanded(child: Text(slot)),
                        ],
                      ),
                    ))
                .toList(),
            const SizedBox(height: 12),
            Text(l10n.translate('connected_clubs'), style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            ...trainer.clubs.map(
              (club) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: club.accentColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text('${club.name} — ${club.city}')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.translate('booking_request_sent'))),
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.calendarCheck),
                  label: Text(l10n.translate('book_session')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${l10n.translate('contact_trainer')} ${trainer.contactPhone}')),
                      );
                    },
                    icon: const FaIcon(FontAwesomeIcons.phone),
                    label: Text(l10n.translate('contact_trainer')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 12, end: 0);
  }
}

class _ClubCard extends StatelessWidget {
  const _ClubCard({required this.club});

  final FitnessClub club;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surface.withOpacity(0.88),
        border: Border.all(color: club.accentColor().withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              club.image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(club.name, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('${club.city} · ${club.address}', style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Text(club.discount, style: theme.textTheme.bodyMedium?.copyWith(color: club.accentColor())),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: club.features
                      .map(
                        (feature) => Chip(
                          avatar: const FaIcon(FontAwesomeIcons.solidCircleCheck, size: 12),
                          label: Text(feature),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${AppLocalizations.of(context).translate('call_club')} ${club.contactNumber}')),
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.locationDot),
                  label: Text(AppLocalizations.of(context).translate('call_club')),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0);
  }
}

class _PassTeaser extends StatelessWidget {
  const _PassTeaser({required this.onViewPass});

  final VoidCallback onViewPass;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate('multi_pass_teaser_title'),
                    style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.translate('multi_pass_teaser_desc'),
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: onViewPass,
                    style: FilledButton.styleFrom(backgroundColor: Colors.white),
                    child: Text(
                      l10n.translate('view_pass'),
                      style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                'https://images.unsplash.com/photo-1506126613408-eca07ce68773',
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0);
  }
}
