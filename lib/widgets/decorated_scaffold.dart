import 'package:flutter/material.dart';

import '../core/design_system.dart';

class DecoratedScaffold extends StatelessWidget {
  const DecoratedScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.extendBody = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.background),
      child: Scaffold(
        extendBody: extendBody,
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: SafeArea(child: body),
        bottomNavigationBar: bottomNavigationBar == null
            ? null
            : Padding(
                padding: const EdgeInsets.all(16),
                child: bottomNavigationBar,
              ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
