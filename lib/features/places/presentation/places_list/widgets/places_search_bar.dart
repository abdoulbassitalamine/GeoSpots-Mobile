import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/utils/utils/debounce.dart';
import '../../../../../shared/design_system/design_system.dart';

class PlacesSearchBar extends HookWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;

  const PlacesSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: searchQuery);
    final debouncer = Debouncer();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.xl,
        vertical: GSSpacing.l,
      ),
      child: GSSearchField(
        controller: controller,
        hintText: 'Rechercher un lieu...',
        onChanged: (value) {
          debouncer.run(() {
            onSearchChanged(value);
          });
        },
        onBack: () {
          controller.clear();
          onClearSearch();
        },
        onClear: () {
          controller.clear();
          onClearSearch();
        },
        title: 'Rechercher un lieu',
      ),
    );
  }
}
