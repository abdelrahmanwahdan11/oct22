import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/models/agent.dart';
import '../../data/repositories/agents_repository.dart';
import '../../widgets/components/agent_card.dart';

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key, required this.repository});

  final AgentsRepository repository;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final agents = repository.fetchAgents();
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('agents')),
      ),
      body: ListView.builder(
        itemCount: agents.length,
        itemBuilder: (context, index) {
          final Agent agent = agents[index];
          return AgentCard(agent: agent, onTap: () {});
        },
      ),
    );
  }
}
