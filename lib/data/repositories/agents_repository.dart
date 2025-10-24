import '../models/agent.dart';

class AgentsRepository {
  AgentsRepository() {
    _agents = _seed.map(Agent.fromJson).toList();
  }

  late final List<Agent> _agents;

  List<Agent> fetchAgents() => _agents;

  Agent? findById(String id) {
    try {
      return _agents.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  static const _seed = [
    {
      'id': 'a1',
      'name': 'Maya Khalil',
      'photo': 'https://i.pravatar.cc/150?img=47',
      'phone': '+970-555111',
      'email': 'maya@re.com',
      'rating': 4.8,
    },
    {
      'id': 'a2',
      'name': 'Omar Haddad',
      'photo': 'https://i.pravatar.cc/150?img=22',
      'phone': '+970-555222',
      'email': 'omar@re.com',
      'rating': 4.6,
    },
  ];
}
