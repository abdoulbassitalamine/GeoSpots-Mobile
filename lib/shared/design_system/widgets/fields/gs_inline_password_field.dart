import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';

class GSInlinePasswordField extends StatelessWidget {
  const GSInlinePasswordField({
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

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: action,
      enableSuggestions: false,
      autocorrect: false,
      cursorColor: GSColorTokens.textAccent,
      style: TextStyle(color: GSColorTokens.textPrimary),
      decoration: InputDecoration(
        label: Text(
          label,
          style: context.bodyDefaultMedium.copyWith(
            color: GSColorTokens.fieldLabel,
          ),
        ),
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
        floatingLabelStyle: TextStyle(color: GSColorTokens.textAccent),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.textAccent),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldBorder),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldError),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldError),
        ),
        suffixIcon: IconButton(
          onPressed: () => onVisibilityChanged?.call(!obscureText),
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: GSColorTokens.textPrimary,
          ),
        ),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
