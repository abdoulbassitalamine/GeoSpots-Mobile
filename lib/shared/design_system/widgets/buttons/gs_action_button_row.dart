import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import 'gs_filled_button.dart';
import 'gs_outlined_button.dart';

class GSActionButtonRow extends StatelessWidget {
  const GSActionButtonRow({
    super.key,
    required this.onSave,
    this.onCancel,
    this.cancelText = 'Annuler',
    this.saveText = 'Enregistrer',
    this.isFormValid = true,
    this.isLoading = false,
  });

  final VoidCallback onSave;
  final VoidCallback? onCancel;
  final String cancelText;
  final String saveText;
  final bool isFormValid;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth > 700 ? screenWidth * 0.1 : 0.0;
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: GSSpacing.m,
      vertical: GSSpacing.l,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: GSSpacing.s,
        runSpacing: GSSpacing.s,
        children: [
          SizedBox(
            width: 140,
            child: GSOutlinedButton(
              onPressed: () {
                onCancel?.call();
              },
              text: cancelText,
              padding: buttonPadding,
              fullWidth: true,
            ),
          ),
          SizedBox(
            width: 140,
            child: GSFilledButton(
              enabled: isFormValid,
              isLoading: isLoading,
              onPressed: onSave,
              text: saveText,
              padding: buttonPadding,
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}
