import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../theme/shadows.dart';
import '../../tokens/color_tokens.dart';

/// GSDropdownField - Dropdown component for GeoSpots
class GSDropdownField<T> extends StatefulWidget {
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
    this.showErrorOnlyWhenUnfocused = true,
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
  final bool showErrorOnlyWhenUnfocused;

  @override
  State<GSDropdownField<T>> createState() => _GSDropdownFieldState<T>();
}

class _GSDropdownFieldState<T> extends State<GSDropdownField<T>> {
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
  void didUpdateWidget(covariant GSDropdownField<T> oldWidget) {
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

    final dropdownItems = widget.items ??
        widget.itemValues?.map((value) {
          return DropdownMenuItem<T>(
            value: value,
            child: widget.itemBuilder!(context, value),
          );
        }).toList();

    return MergeSemantics(
      child: Semantics(
        child: DropdownButtonFormField2<T>(
          value: widget.value,
          focusNode: _effectiveFocusNode,
          items: dropdownItems,
          onChanged: widget.enabled ? widget.onChanged : null,
          onSaved: widget.onSaved,
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
            labelText: widget.label,
            labelStyle: GSTypography.bodyDefaultSmall.copyWith(
              color: GSColorTokens.textPrimary,
              fontWeight: FontWeight.w400,
              fontSize: GSFontScale.sf04,
            ),
            floatingLabelStyle: TextStyle(
              color: GSColorTokens.textAccent,
            ),
            hintText: widget.placeholder,
            hintStyle: TextStyle(
              color: GSColorTokens.fieldLabel,
            ),
            errorText: shouldShowError ? widget.errorMessage : null,
            prefixIcon: widget.leadingIcon,
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
