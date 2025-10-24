import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/utils/animations.dart';
import '../../data/models/agent.dart';

class AgentCard extends StatelessWidget {
  const AgentCard({super.key, required this.agent, this.onTap});

  final Agent agent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(agent.photo),
      ),
      title: Text(agent.name),
      subtitle: Row(
        children: [
          const FaIcon(FontAwesomeIcons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 6),
          Text('${agent.rating.toStringAsFixed(1)}'),
        ],
      ),
      trailing: IconButton(
        icon: const FaIcon(FontAwesomeIcons.phone, size: 16),
        onPressed: () {},
      ),
    ).fadeMove();
  }
}
