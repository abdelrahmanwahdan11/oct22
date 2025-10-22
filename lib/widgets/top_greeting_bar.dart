import 'package:flutter/material.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/core/design_tokens.dart';

class TopGreetingBar extends StatelessWidget {
  const TopGreetingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final auth = scope.auth;
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: auth,
      builder: (context, _) {
        final loc = auth.localization;
        final greeting = loc.t('greeting').replaceAll('{name}', auth.displayName);
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
                    greeting,
                    style: theme.textTheme.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.t('greeting_subtitle'),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        );
      },
    );
  }
}
