import 'package:flutter/material.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/widgets/access_toggle_row.dart';

class UserAccessScreen extends StatelessWidget {
  const UserAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).access;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final rules = controller.rules;
        return Scaffold(
          appBar: AppBar(title: const Text('User Access')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(16, 24, 40, 0.08),
                          blurRadius: 32,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smarter Living, Managed Together',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Share control with family, with your permission.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Edit Member'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: rules.length,
                      itemBuilder: (context, index) {
                        final rule = rules[index];
                        return AccessToggleRow(
                          title: rule.title,
                          subtitle: rule.description,
                          enabled: rule.enabled,
                          onChanged: (value) => controller.toggle(rule.id, value),
                        );
                      },
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
