import 'package:flutter/material.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/widgets/bar_chart.dart';

class MonthlyAnalysisScreen extends StatelessWidget {
  const MonthlyAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).energy;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final points = controller.points;
        return Scaffold(
          appBar: AppBar(title: const Text('Monthly Analysis')),
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
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, color: Color(0xFF117BDB)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Energy Consumption',
                                style: Theme.of(context).textTheme.titleMedium),
                            Text('Monthly', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '1632kwh',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                  ),
                  Text(
                    '+12% higher than previous 6 months',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: EnergyBarChart(
                      points: points,
                      highlight: controller.highlight,
                      onSelect: controller.setHighlight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: const [
                      _DeviceEnergyRow(
                        icon: Icons.ac_unit,
                        title: 'Air Conditioner',
                        subtitle: 'Highly Consumption',
                        value: '570kwh',
                      ),
                      _DeviceEnergyRow(
                        icon: Icons.tv,
                        title: 'Smart TV',
                        subtitle: 'Moderate Consumption',
                        value: '120kwh',
                      ),
                    ],
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

class _DeviceEnergyRow extends StatelessWidget {
  const _DeviceEnergyRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 24, 40, 0.06),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF117BDB)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
