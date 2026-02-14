import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../theme/shadows.dart';
import '../../tokens/color_tokens.dart';

/// GSDropdownField - Dropdown component for GeoSpots
class GSDropdownField<T> extends StatelessWidget {
  const GSDropdownField({
    super.key,
    this.items,
    this.itemBuilder,
    this.itemValues,
    this.value,
    this.onChanged,
    this.onSaved,
    this.enabled = true,
    this.label,
    this.errorMessage,
    this.leadingIcon,
    this.hint,
    this.height,
    this.width,
    this.placeholder,
    this.focusNode,
  }) : assert(
  (items != null) != ((itemBuilder != null && itemValues != null)),
  'Either provide items or both itemBuilder and itemValues',
  );

  final List<DropdownMenuItem<T>>? items;
  final Widget Function(BuildContext, T)? itemBuilder;
  final List<T>? itemValues;
  final T? value;
  final void Function(T?)? onChanged;
  final void Function(T?)? onSaved;
  final bool enabled;
  final String? label;
  final String? errorMessage;
  final Widget? leadingIcon;
  final Widget? hint;
  final double? height;
  final double? width;
  final String? placeholder;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final dropdownItems = items ??
        itemValues?.map((value) {
          return DropdownMenuItem<T>(
            value: value,
            child: itemBuilder!(context, value),
          );
        }).toList();

    return MergeSemantics(
      child: Semantics(
        child: DropdownButtonFormField2<T>(
          value: value,
          focusNode: focusNode,
          items: dropdownItems,
          onChanged: enabled ? onChanged : null,
          onSaved: onSaved,
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: GSColorTokens.backgroundPrimary,
              borderRadius: BorderRadius.circular(GSRadius.s),
              boxShadow: [
                GSShadows.s(),
              ],
            ),
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GSTypography.bodyDefaultSmall.copyWith(
              color: GSColorTokens.textPrimary,
              fontWeight: FontWeight.w400,
              fontSize: GSFontScale.sf04,
            ),
            floatingLabelStyle: TextStyle(
              color: GSColorTokens.textAccent,
            ),
            hintText: placeholder,
            hintStyle: TextStyle(
              color: GSColorTokens.fieldLabel,
            ),
            errorText: errorMessage,
            prefixIcon: leadingIcon,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: GSSpacing.xs,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GSRadius.s),
              borderSide: BorderSide(
                color: GSColorTokens.textAccent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GSRadius.s),
              borderSide: BorderSide(
                color: GSColorTokens.fieldBorder,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GSRadius.s),
              borderSide: BorderSide(
                color: GSColorTokens.fieldBorder.withValues(alpha: .5),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GSRadius.s),
              borderSide: BorderSide(
                color: GSColorTokens.fieldError,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GSRadius.s),
            ),
            filled: false,
          ),
        ),
      ),
    );
  }
}