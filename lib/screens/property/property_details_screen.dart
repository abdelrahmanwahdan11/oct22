import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/animations.dart';
import '../../data/models/property.dart';
import '../../widgets/components/bottom_action_bar.dart';
import '../../widgets/components/property_card.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  double _downPayment = 0.2;
  double _interest = 4.2;
  double _term = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = NotifierProvider.read<PropertiesController>(context);
      controller.registerView(widget.propertyId);
    });
  }

  double _monthlyPayment(Property property) {
    final loan = property.price * (1 - _downPayment);
    final rate = _interest / 100 / 12;
    final months = _term * 12;
    if (rate == 0) {
      return loan / months;
    }
    final factor = math.pow(1 + rate, months);
    return loan * (rate * factor) / (factor - 1);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final controller = NotifierProvider.of<PropertiesController>(context);
    final Property? property = controller.findById(widget.propertyId);
    if (property == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(strings.t('no_results'))),
      );
    }
    final similar = controller.similarTo(property.id);
    final energyClass = property.features.contains('Solar panels')
        ? 'A+'
        : property.areaM2 > 320
            ? 'A'
            : property.areaM2 > 180
                ? 'B+'
                : 'B';
    final payment = _monthlyPayment(property);
    final listedDate =
        '${property.postedAt.year}-${property.postedAt.month.toString().padLeft(2, '0')}-${property.postedAt.day.toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 18),
            onPressed: () {},
          ),
          IconButton(
            icon: FaIcon(
              property.favorite
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              size: 18,
            ),
            onPressed: () => controller.toggleFavorite(property),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          Hero(
            tag: 'property_image_${property.id}',
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: Image.network(
                property.images.first,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ).fadeMove(),
          Padding(
            padding: const EdgeInsets.all(24),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ).fadeMove(),
                const SizedBox(height: 8),
                Text('${property.currency} ${property.price}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700))
                    .fadeMove(delay: 60),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _InfoPill(icon: FontAwesomeIcons.bed, label: '${property.beds}'),
                    _InfoPill(icon: FontAwesomeIcons.bath, label: '${property.baths}'),
                    _InfoPill(icon: FontAwesomeIcons.rulerCombined, label: '${property.areaM2} m²'),
                    _InfoPill(icon: FontAwesomeIcons.locationDot, label: property.city),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: property.features
                      .map((feature) => Chip(label: Text(feature)))
                      .toList(),
                ).fadeMove(delay: 120),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.bolt, size: 16),
                      const SizedBox(width: 8),
                      Text('${strings.t('energy_label')} $energyClass'),
                    ],
                  ),
                ).fadeMove(delay: 140),
                const SizedBox(height: 16),
                Text(
                  strings.t('description'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ).fadeMove(delay: 160),
                const SizedBox(height: 8),
                Text(
                  property.description ?? strings.t('no_results'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ).fadeMove(delay: 200),
                const SizedBox(height: 24),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.mapLocationDot, size: 24),
                        const SizedBox(height: 8),
                        Text('${property.lat}, ${property.lng}')
                      ],
                    ),
                  ),
                ).fadeMove(delay: 240),
                const SizedBox(height: 24),
                _FinancePlanner(
                  strings: strings,
                  downPayment: _downPayment,
                  interest: _interest,
                  term: _term,
                  payment: payment,
                  onDownPaymentChanged: (value) => setState(() => _downPayment = value),
                  onInterestChanged: (value) => setState(() => _interest = value),
                  onTermChanged: (value) => setState(() => _term = value),
                ).fadeMove(delay: 260),
                const SizedBox(height: 24),
                Text(
                  strings.t('property_timeline'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ).fadeMove(delay: 280),
                const SizedBox(height: 12),
                _TimelineItem(
                  icon: FontAwesomeIcons.calendarCheck,
                  title: strings.t('listed_on'),
                  subtitle: listedDate,
                ),
                _TimelineItem(
                  icon: FontAwesomeIcons.screwdriverWrench,
                  title: strings.t('recent_upgrades'),
                  subtitle: strings.t('recent_upgrades_desc'),
                ),
                _TimelineItem(
                  icon: FontAwesomeIcons.spa,
                  title: strings.t('comfort_features'),
                  subtitle: property.features.join(', '),
                ),
                const SizedBox(height: 24),
                if (similar.isNotEmpty) ...[
                  Text(
                    strings.t('similar_properties'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ).fadeMove(delay: 300),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => SizedBox(
                        width: 240,
                        child: PropertyCard(property: similar[index], index: index),
                      ),
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemCount: similar.length,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        onBook: () => Navigator.of(context)
            .pushNamed('booking.sheet', arguments: property.id),
        onContact: () => Navigator.of(context)
            .pushNamed('booking.sheet', arguments: property.id),
        onWhatsApp: () {},
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 14),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    ).fadeMove();
  }
}

class _FinancePlanner extends StatelessWidget {
  const _FinancePlanner({
    required this.strings,
    required this.downPayment,
    required this.interest,
    required this.term,
    required this.payment,
    required this.onDownPaymentChanged,
    required this.onInterestChanged,
    required this.onTermChanged,
  });

  final AppLocalizations strings;
  final double downPayment;
  final double interest;
  final double term;
  final double payment;
  final ValueChanged<double> onDownPaymentChanged;
  final ValueChanged<double> onInterestChanged;
  final ValueChanged<double> onTermChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.sectionSurface(dark: Theme.of(context).brightness == Brightness.dark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.t('finance_planner'),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            strings.t('estimated_payment_label') +
                ' ${payment.toStringAsFixed(0)} ${strings.t('currency_monthly')}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _SliderTile(
            label: strings.t('down_payment'),
            value: downPayment,
            min: 0.0,
            max: 0.5,
            formatter: (value) => '${(value * 100).round()}%',
            onChanged: onDownPaymentChanged,
          ),
          _SliderTile(
            label: strings.t('interest_rate'),
            value: interest,
            min: 1,
            max: 8,
            formatter: (value) => '${value.toStringAsFixed(1)}%',
            onChanged: onInterestChanged,
          ),
          _SliderTile(
            label: strings.t('loan_term'),
            value: term,
            min: 5,
            max: 30,
            formatter: (value) => '${value.round()} ${strings.t('years')}',
            onChanged: onTermChanged,
          ),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.formatter,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String Function(double) formatter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(formatter(value), style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 10).round(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: FaIcon(icon, size: 18),
      title: Text(title),
      subtitle: Text(subtitle),
    ).fadeMove();
  }
}
