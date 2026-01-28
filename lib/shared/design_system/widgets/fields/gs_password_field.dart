import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/tokens/color_tokens.dart';

import '../../theme/text_styles.dart';

class GSPasswordField extends StatelessWidget {
  const GSPasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.type,
    this.action,
    this.onChanged,
    this.onSubmitted,
    this.error,
    required this.obscureText,
    this.onVisibilityChanged,
    this.errorMessage,
  });

  final String label;
  final String? error;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType? type;
  final TextInputAction? action;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onVisibilityChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: action,
      enableSuggestions: false,
      autocorrect: false,
      maxLines: 1,
      cursorColor: GSColorTokens.textAccent,
      style: TextStyle(color: GSColorTokens.textPrimary),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: GSColorTokens.textPrimary),
        floatingLabelStyle: TextStyle(color: GSColorTokens.textPrimary),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.textAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldBorder),
        ),
        labelText: label,
        errorText: errorMessage,
        border: const OutlineInputBorder(),
        filled: false,
        error: error == null
            ? null
            : Align(
                alignment: Alignment.centerRight,
                child: Text(
                  error!,
                  textAlign: TextAlign.end,
                  style: context.bodyAccentMedium.copyWith(
                    color: GSColorTokens.fieldError,
                  ),
                ),
              ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldError),
        ),
        suffixIcon: onVisibilityChanged != null
            ? IconButton(
                onPressed: () => onVisibilityChanged?.call(!obscureText),
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: GSColorTokens.textPrimary,
                ),
              )
            : null,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
