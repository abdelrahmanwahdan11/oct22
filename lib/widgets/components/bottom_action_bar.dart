import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    this.onBook,
    this.onContact,
    this.onWhatsApp,
  });

  final VoidCallback? onBook;
  final VoidCallback? onContact;
  final VoidCallback? onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: onBook,
                icon: const FaIcon(FontAwesomeIcons.calendarCheck, size: 16),
                label: Text(strings.t('book_visit')),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: onContact,
                icon: const FaIcon(FontAwesomeIcons.phone, size: 16),
                label: Text(strings.t('contact_agent')),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: onWhatsApp,
                icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 16),
                label: Text(strings.t('whatsapp')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
