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
      padding: const EdgeInsets.all(GSSpacing.m),
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
          const SizedBox(height: GSSpacing.xs),
          GSTextField(
            controller: controller,
            maxLines: 1,
            placeholder: 'Rechercher dans la collection',
            hintStyle: GSTypography.bodyDefaultMedium.copyWith(
              color: GSColors.neutral500,
            ),
            leadingIcon: const Icon(Icons.search),
            onValueChange: onChanged,
          ),
        ],
      ),
    );
  }
}
