import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';

class CollectionSearchField extends StatelessWidget {
  const CollectionSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return GSTextField(
      controller: controller,
      placeholder: 'Rechercher un lieu dans la collection',
      leadingIcon: const Icon(Icons.search),
      onValueChange: onChanged,
    );
  }
}
