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
    return GSPremiumPanel(
      padding: const EdgeInsets.all(GSSpacing.l),
      backgroundColor: GSColors.neutral000,
      borderColor: GSColors.neutral150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recherche',
            style: GSTypography.labelDefault.copyWith(
              color: GSColors.neutral700,
            ),
          ),
          const SizedBox(height: GSSpacing.s),
          GSTextField(
            controller: controller,
            placeholder: 'Rechercher un lieu dans la collection',
            leadingIcon: const Icon(Icons.search),
            onValueChange: onChanged,
          ),
        ],
      ),
    );
  }
}
