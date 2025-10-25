import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../animations/animated_reveal.dart';

class SearchBarDark extends StatelessWidget {
  const SearchBarDark({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onFilters,
    this.onMic,
    this.controller,
    this.focusNode,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilters;
  final VoidCallback? onMic;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final colors = TradeXTheme.colorsOf(context);
    return AnimatedReveal(
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceSoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.magnifyingGlass, color: colors.muted, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: colors.textSecondary),
              ),
            ),
          ),
          if (onFilters != null) ...[
            IconButton(
              icon: FaIcon(FontAwesomeIcons.sliders, color: colors.muted, size: 18),
              onPressed: onFilters,
            ),
          ],
          if (onMic != null) ...[
            IconButton(
              icon: FaIcon(FontAwesomeIcons.microphone, color: colors.muted, size: 18),
              onPressed: onMic,
            ),
          ],
        ],
      ),
    );
  }
}
