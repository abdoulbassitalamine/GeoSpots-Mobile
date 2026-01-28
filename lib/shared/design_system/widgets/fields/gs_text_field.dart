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
class GSTextField extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: keyboardActions,
          obscureText: obscureText,
          expands: expands,
          focusNode: focusNode,
          onChanged: onValueChange,
          onSubmitted: onSubmitted,
          textCapitalization:
          textCapitalization != true
              ? TextCapitalization.none
              : TextCapitalization.characters,
          keyboardAppearance:
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
          maxLength: characterCounter,
          enabled: enabled,
          readOnly: readOnly,
          minLines: maxLines != null ? minLines ?? 1 : null,
          maxLines: maxLines,
          style:
          inputStyle ??
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
            error == null
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
            focusedBorder:
            focusBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                    GSColorTokens.borderAccent,
                  ),
                ),
            enabledBorder:
            enabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GSColorTokens.fieldBorder,
                  ),
                ),
            prefixIcon: leadingIcon,
            suffixIcon:
            onVisibilityChanged != null
                ? IconButton(
              onPressed: () => onVisibilityChanged?.call(!obscureText),
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color:
                GSColorTokens.textPrimary,

              ),
            )
                : trailingText != null
                ? Padding(
              padding: const EdgeInsets.all(GSSpacing.$100),
              child: Text(
                trailingText!,
                style: TextStyle(
                  color:
                  GSColorTokens.textPrimary,
                ),
              ),
            )
                : trailingIcon,
            labelText: label,
            hintText: placeholder,
            hintStyle:
            hintStyle ??
                TextStyle(color: GSColorTokens.fieldLabel),
            errorText: errorMessage,
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
