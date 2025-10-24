import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/models/agent.dart';

class AgentDetailsScreen extends StatelessWidget {
  const AgentDetailsScreen({super.key, required this.agent});

  final Agent agent;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(agent.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(radius: 48, backgroundImage: NetworkImage(agent.photo)),
            const SizedBox(height: 16),
            Text(
              agent.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text(agent.rating.toStringAsFixed(1)),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.phone, size: 16),
              title: Text(agent.phone),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.solidEnvelope, size: 16),
              title: Text(agent.email),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.phone, size: 16),
              label: Text(strings.t('contact_agent')),
            ),
          ],
        ),
      ),
    );
  }
}
