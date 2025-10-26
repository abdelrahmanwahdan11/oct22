import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_localizations.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({
    super.key,
    required this.onChanged,
    required this.onFilters,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onFilters;

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.86),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: l10n.translate('search_hint'),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.sliders, size: 18),
            onPressed: widget.onFilters,
          ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0, curve: Curves.easeOut),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.barcode, size: 18),
            onPressed: () {},
          ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0, curve: Curves.easeOut),
        ],
      ),
    ).animate().fadeIn(260.ms).moveY(begin: 14, end: 0, curve: Curves.easeOut);
  }
}
