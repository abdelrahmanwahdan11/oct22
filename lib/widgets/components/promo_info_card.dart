import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/animations.dart';

class PromoInfoCard extends StatelessWidget {
  const PromoInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1501183638710-841dd1904471'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const FaIcon(FontAwesomeIcons.bolt, size: 16, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Text(
                  strings.t('finance_spotlight'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  strings.t('finance_value'),
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                Text(
                  strings.t('finance_desc'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ],
        ),
      ),
    ).fadeMove();
  }
}
