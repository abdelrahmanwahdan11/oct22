import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final formContent = SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 48 : 24,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        title,
                        style: theme.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
                      form,
                      if (footer != null) ...[
                        const SizedBox(height: 24),
                        footer!,
                      ],
                    ],
                  ),
                ),
              ),
            );

            if (!isWide) {
              return formContent;
            }

            return Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2EA6FF), Color(0xFF117BDB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/room_living.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Color(0x66000000), BlendMode.darken),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          subtitle,
                          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: formContent),
              ],
            );
          },
        ),
      ),
    );
  }
}
