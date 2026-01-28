import 'package:flutter/material.dart';
import 'gs_filled_button.dart';
import 'gs_outlined_button.dart';
import '../../theme/spacing.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 700 ? screenWidth * 0.1 : GSSpacing.xl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GSOutlinedButton(
              onPressed: () {
                onCancel?.call();
                Navigator.of(context).pop();
              },
              text: cancelText,
            ),
          ),
          const SizedBox(width: GSSpacing.xl4),
          Expanded(
            child: GSFilledButton(
              enabled: isFormValid,
              isLoading: isLoading,
              onPressed: onSave,
              text: saveText,
            ),
          ),
        ],
      ),
    );
  }
}
