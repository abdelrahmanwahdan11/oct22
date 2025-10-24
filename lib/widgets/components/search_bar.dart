import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/utils/animations.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final properties = NotifierProvider.read<PropertiesController>(context);
    _controller = TextEditingController(text: properties.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final properties = NotifierProvider.of<PropertiesController>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 24, 40, 0.06),
            blurRadius: 24,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: properties.setSearchQuery,
              onSubmitted: (value) => properties.registerSearch(value),
              decoration: InputDecoration(
                hintText: strings.t('search_hint'),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.sliders, size: 18),
            onPressed: () => Navigator.of(context).pushNamed('filters.sheet'),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.microphone, size: 18),
            onPressed: () {},
          ),
        ],
      ),
    ).fadeMove();
  }
}
