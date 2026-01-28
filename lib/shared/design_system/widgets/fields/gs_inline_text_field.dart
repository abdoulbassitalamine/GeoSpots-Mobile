import 'package:flutter/material.dart';

import '../../design_system.dart';

class GSInlineTextField extends StatelessWidget {
  const GSInlineTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.type,
    this.action,
    this.onChanged,
    this.onSubmitted,
    this.error,
    this.maxLines,
  });

  final String label;
  final String? error;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType? type;
  final TextInputAction? action;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: type ?? TextInputType.text,
      textInputAction: action,
      maxLines: maxLines,
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
        floatingLabelStyle: TextStyle(color: GSColorTokens.fieldLabel),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldBorder),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.textAccent),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldError),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldError),
        ),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}