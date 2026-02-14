/*
 * Software Name : Gsange Design System
 * SPDX-FileCopyrightText: Copyright (c) Gsange SA
 * SPDX-License-Identifier: MIT
 *
 * This software is distributed under the MIT license,
 * the text of which is available at https://opensource.org/license/MIT/
 * or see the "LICENSE" file for more details.
 *
 * Software description: Flutter library of reusable graphical components for Android and iOS
 */

import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../../theme/text_styles.dart';
import '../../tokens/color_tokens.dart';

/// GSTextField.
///
/// A text field lets the user enter text, either with hardware keyboard or with an onscreen keyboard.
///
///.
class GSTextField extends StatefulWidget {
  const GSTextField({
    super.key,
    this.controller,
    this.onClick,
    this.enabled,
    this.readOnly = false,
    this.errorMessage,
    this.label,
    this.placeholder,
    this.keyboardType,
    this.keyboardActions,
    this.trailingText,
    this.trailingIcon,
    this.leadingIcon,
    this.characterCounter,
    this.maxLines,
    this.minLines,
    this.expands = false,
    this.textCapitalization = false,
    this.onValueChange,
    this.focusNode,
    this.onSubmitted,
    this.inputStyle,
    this.hintStyle,
    this.focusBorder,
    this.enabledBorder,
    this.error,
    this.obscureText = false,
    this.onVisibilityChanged,
    this.showErrorOnlyWhenUnfocused = true,
  });

  final TextEditingController? controller;
  final void Function(String)? onClick;
  final bool? enabled;
  final bool readOnly;
  final String? errorMessage;
  final String? label;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? keyboardActions;
  final String? trailingText;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final int? characterCounter;
  final int? maxLines;
  final int? minLines;
  final bool? textCapitalization;
  final void Function(String)? onValueChange;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  final TextStyle? inputStyle;
  final TextStyle? hintStyle;
  final bool expands;
  final OutlineInputBorder? focusBorder;
  final OutlineInputBorder? enabledBorder;
  final String? error;
  final ValueChanged<bool>? onVisibilityChanged;
  final bool obscureText;
  final bool showErrorOnlyWhenUnfocused;

  @override
  State<GSTextField> createState() => _GSTextFieldState();
}

class _GSTextFieldState extends State<GSTextField> {
  FocusNode? _internalFocusNode;
  bool _hasBeenFocused = false;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode == null ? FocusNode() : null;
    _effectiveFocusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant GSTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      final oldFocusNode = oldWidget.focusNode ?? _internalFocusNode;
      oldFocusNode?.removeListener(_onFocusChanged);
      if (oldWidget.focusNode != null && widget.focusNode == null) {
        _internalFocusNode = FocusNode();
      }
      _effectiveFocusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChanged);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_effectiveFocusNode.hasFocus && !_hasBeenFocused) {
      setState(() => _hasBeenFocused = true);
      return;
    }
    if (!_effectiveFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowError =
        !widget.showErrorOnlyWhenUnfocused ||
        (_hasBeenFocused && !_effectiveFocusNode.hasFocus);
    return MergeSemantics(
      child: Semantics(
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.keyboardActions,
          obscureText: widget.obscureText,
          expands: widget.expands,
          focusNode: _effectiveFocusNode,
          onChanged: widget.onValueChange,
          onSubmitted: widget.onSubmitted,
          textCapitalization:
          widget.textCapitalization != true
              ? TextCapitalization.none
              : TextCapitalization.characters,
          keyboardAppearance:
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
          maxLength: widget.characterCounter,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          minLines: widget.maxLines != null ? widget.minLines ?? 1 : null,
          maxLines: widget.maxLines,
          style:
          widget.inputStyle ??
              context.bodyDefaultMedium.copyWith(
                color: GSColorTokens.textPrimary,
              ),
          cursorColor: GSColorTokens.textAccent,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: GSColorTokens.textPrimary,
            ),
            floatingLabelStyle: TextStyle(
              color: GSColorTokens.textPrimary,
            ),
            error:
            widget.error == null || !shouldShowError
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
            focusedBorder:
            widget.focusBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                    GSColorTokens.borderAccent,
                  ),
                ),
            enabledBorder:
            widget.enabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GSColorTokens.fieldBorder,
                  ),
                ),
            prefixIcon: widget.leadingIcon,
            suffixIcon:
            widget.onVisibilityChanged != null
                ? IconButton(
              onPressed: () => widget.onVisibilityChanged?.call(!widget.obscureText),
              icon: Icon(
                widget.obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color:
                GSColorTokens.textPrimary,

              ),
            )
                : widget.trailingText != null
                ? Padding(
              padding: const EdgeInsets.all(GSSpacing.$100),
              child: Text(
                widget.trailingText!,
                style: TextStyle(
                  color:
                  GSColorTokens.textPrimary,
                ),
              ),
            )
                : widget.trailingIcon,
            labelText: widget.label,
            hintText: widget.placeholder,
            hintStyle:
            widget.hintStyle ??
                TextStyle(color: GSColorTokens.fieldLabel),
            errorText: shouldShowError ? widget.errorMessage : null,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: GSColorTokens.borderPrimary,
              ),
            ),
            filled: false,
          ),
        ),
      ),
    );
  }
}
