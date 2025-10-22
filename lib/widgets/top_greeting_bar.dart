import 'package:flutter/material.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class TopGreetingBar extends StatelessWidget {
  const TopGreetingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: const AssetImage('assets/images/avatar_user.png'),
          backgroundColor: AppColors.blueSoft,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Jhon Snow',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Set Up Devices. Take Control',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }
}
