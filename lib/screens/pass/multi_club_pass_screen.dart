import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/app_scope.dart';
import '../../data/models/membership_pass.dart';

class MultiClubPassScreen extends StatelessWidget {
  const MultiClubPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passController = AppScope.of(context).passController;
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: passController,
      builder: (context, _) {
        final pass = passController.pass;
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
              child: pass == null
                  ? const Center(child: CircularProgressIndicator())
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          title: Text(l10n.translate('multi_pass_title')),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _PassCard(pass: pass),
                                const SizedBox(height: 24),
                                Text(l10n.translate('pass_perks'),
                                    style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: 12),
                                ...pass.perks
                                    .map(
                                      (perk) => ListTile(
                                        leading: const FaIcon(FontAwesomeIcons.solidCircleCheck, color: Color(0xFF4AC6A8)),
                                        title: Text(perk),
                                      ),
                                    )
                                    .toList(),
                                const SizedBox(height: 24),
                                Text(l10n.translate('included_clubs'),
                                    style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: 12),
                                ...pass.includedClubs
                                    .map(
                                      (club) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: Row(
                                          children: [
                                            const FaIcon(FontAwesomeIcons.locationDot, size: 16),
                                            const SizedBox(width: 10),
                                            Expanded(child: Text(club)),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                const SizedBox(height: 24),
                                Text(l10n.translate('weekly_schedule'),
                                    style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: 12),
                                ...pass.weeklySchedule.entries.map(
                                  (entry) => _ScheduleRow(day: entry.key, sessions: entry.value),
                                ),
                                const SizedBox(height: 24),
                                FilledButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(l10n.translate('pass_reserved'))),
                                    );
                                  },
                                  icon: const FaIcon(FontAwesomeIcons.ticket),
                                  label: Text('${l10n.translate('subscribe_now')} · ${pass.pricePerMonth.toStringAsFixed(0)} SAR'),
                                ),
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

class _PassCard extends StatelessWidget {
  const _PassCard({required this.pass});

  final MembershipPass pass;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expiration = '${pass.expiration.year}/${pass.expiration.month}/${pass.expiration.day}';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              pass.image,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.25),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pass.name,
                        style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(expiration, style: theme.textTheme.labelMedium?.copyWith(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(pass.description,
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.84))),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: pass.includedClubs
                      .take(3)
                      .map(
                        (club) => Chip(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          label: Text(club, style: const TextStyle(color: Colors.white)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0);
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.day, required this.sessions});

  final String day;
  final List<String> sessions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...sessions.map(
            (session) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.clock, size: 14),
                  const SizedBox(width: 8),
                  Expanded(child: Text(session)),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 10, end: 0);
  }
}
