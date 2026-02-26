import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/utils/utils/debounce.dart';
import '../../../../../shared/design_system/design_system.dart';

class PlacesSearchBar extends HookWidget {
  const PlacesSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
  });
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: searchQuery);
    final focusNode = useFocusNode();
    final isExpanded = useState(false);
    final debouncer = Debouncer();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.xl,
        vertical: GSSpacing.l,
      ),
      child: GSSearchField(
        controller: controller,
        focusNode: focusNode,
        isExpanded: isExpanded.value,
        onExpandedChanged: (value) => isExpanded.value = value,
        hintText: 'Rechercher un lieu...',
        onChanged: (value) {
          debouncer.run(() {
            onSearchChanged(value);
          });
        },
        onBack: () {
          controller.clear();
          isExpanded.value = false;
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
