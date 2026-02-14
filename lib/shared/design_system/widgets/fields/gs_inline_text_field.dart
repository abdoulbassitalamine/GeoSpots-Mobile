import 'package:flutter/material.dart';

import '../../design_system.dart';

class GSInlineTextField extends StatefulWidget {
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
    this.showErrorOnlyWhenUnfocused = true,
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
  final bool showErrorOnlyWhenUnfocused;

  @override
  State<GSInlineTextField> createState() => _GSInlineTextFieldState();
}

class _GSInlineTextFieldState extends State<GSInlineTextField> {
  bool _hasBeenFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant GSInlineTextField oldWidget) {
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
      keyboardType: widget.type ?? TextInputType.text,
      textInputAction: widget.action,
      maxLines: widget.maxLines,
      cursorColor: GSColorTokens.textAccent,
      style: TextStyle(color: GSColorTokens.textPrimary),
      decoration: InputDecoration(
        label: Text(
          widget.label,
          style: context.bodyDefaultMedium.copyWith(
            color: GSColorTokens.fieldLabel,
          ),
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
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
