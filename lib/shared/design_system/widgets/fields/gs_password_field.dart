import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/tokens/color_tokens.dart';

import '../../theme/text_styles.dart';

class GSPasswordField extends StatefulWidget {
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
    this.showErrorOnlyWhenUnfocused = true,
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
  final bool showErrorOnlyWhenUnfocused;

  @override
  State<GSPasswordField> createState() => _GSPasswordFieldState();
}

class _GSPasswordFieldState extends State<GSPasswordField> {
  bool _hasBeenFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant GSPasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChanged);
      widget.focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    if (widget.focusNode.hasFocus && !_hasBeenFocused) {
      setState(() => _hasBeenFocused = true);
      return;
    }
    if (!widget.focusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowError =
        !widget.showErrorOnlyWhenUnfocused ||
        (_hasBeenFocused && !widget.focusNode.hasFocus);

    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.obscureText,
      textInputAction: widget.action,
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
        labelText: widget.label,
        errorText: shouldShowError ? widget.errorMessage : null,
        border: const OutlineInputBorder(),
        filled: false,
        error: widget.error == null || !shouldShowError
            ? null
            : Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.error!,
                  textAlign: TextAlign.end,
                  style: context.bodyAccentMedium.copyWith(
                    color: GSColorTokens.fieldError,
                  ),
                ),
              ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldError),
        ),
        suffixIcon: widget.onVisibilityChanged != null
            ? IconButton(
                onPressed: () => widget.onVisibilityChanged?.call(!widget.obscureText),
                icon: Icon(
                  widget.obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: GSColorTokens.textPrimary,
                ),
              )
            : null,
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
