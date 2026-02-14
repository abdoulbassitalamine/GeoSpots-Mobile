import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';

class GSInlinePasswordField extends StatefulWidget {
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
  final bool showErrorOnlyWhenUnfocused;

  @override
  State<GSInlinePasswordField> createState() => _GSInlinePasswordFieldState();
}

class _GSInlinePasswordFieldState extends State<GSInlinePasswordField> {
  bool _hasBeenFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant GSInlinePasswordField oldWidget) {
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
      cursorColor: GSColorTokens.textAccent,
      style: TextStyle(color: GSColorTokens.textPrimary),
      decoration: InputDecoration(
        label: Text(
          widget.label,
          style: context.bodyDefaultMedium.copyWith(color: GSColorTokens.fieldLabel),
        ),
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
        floatingLabelStyle: TextStyle(color: GSColorTokens.textAccent),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.textAccent),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GSColorTokens.fieldBorder),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: GSColorTokens.fieldError,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: GSColorTokens.fieldError,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () => widget.onVisibilityChanged?.call(!widget.obscureText),
          icon: Icon(
            widget.obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: GSColorTokens.textPrimary,
          ),
        ),
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
