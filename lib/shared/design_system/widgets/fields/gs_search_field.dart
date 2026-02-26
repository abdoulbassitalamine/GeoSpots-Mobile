import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';
import 'gs_text_field.dart';

const _kExpanded = 'expanded';
const _kCollapsed = 'collapsed';

class GSSearchField extends StatelessWidget {
  const GSSearchField({
    super.key,
    required this.title,
    this.hintText,
    this.onChanged,
    this.onClear,
    this.onBack,
    required this.controller,
    required this.focusNode,
    this.isExpanded = false,
    this.onExpandedChanged,
    this.collapsePadding,
    this.expandedPadding,
  });

  final String title;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isExpanded;
  final ValueChanged<bool>? onExpandedChanged;
  final EdgeInsetsGeometry? collapsePadding;
  final EdgeInsetsGeometry? expandedPadding;

  void _handleExpand() {
    onExpandedChanged?.call(true);
    focusNode.requestFocus();
  }

  void _handleBack() {
    onExpandedChanged?.call(false);
    controller.clear();
    onBack?.call();
  }

  void _handleClear() {
    controller.clear();
    onChanged?.call('');
    onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GSSpacing.xl8,
      decoration: BoxDecoration(color: GSColorTokens.backgroundSecondary),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isExpanded
            ? _buildExpandedState(context)
            : _buildCollapsedState(context),
      ),
    );
  }

  Widget _buildCollapsedState(BuildContext context) {
    return GestureDetector(
      key: const ValueKey(_kCollapsed),
      onTap: _handleExpand,
      child: Container(
        padding:
            collapsePadding ??
            const EdgeInsets.symmetric(horizontal: GSSpacing.xl),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GSTypography.headingSmall.copyWith(
                  color: GSColorTokens.textPrimary,
                ),
              ),
            ),
            Icon(Icons.search, color: GSColorTokens.textPrimary),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedState(BuildContext context) {
    final textStyle = GSTypography.bodyDefaultLarge.copyWith(
      color: GSColorTokens.textPrimary,
      fontWeight: FontWeight.w700,
      fontSize: GSFontScale.sf06,
    );

    const border = OutlineInputBorder(borderSide: BorderSide.none);
    final hasText = controller.text.isNotEmpty;

    return GSTextField(
      key: const ValueKey(_kExpanded),
      maxLines: 1,
      focusBorder: border,
      enabledBorder: border,
      controller: controller,
      focusNode: focusNode,
      placeholder: hintText,
      hintStyle: textStyle,
      inputStyle: textStyle,
      onValueChange: onChanged,
      leadingIcon: IconButton(
        onPressed: _handleBack,
        icon: const Icon(Icons.arrow_back),
        color: GSColorTokens.textPrimary,
      ),
      trailingIcon: hasText
          ? IconButton(
              onPressed: _handleClear,
              icon: const Icon(Icons.close),
              color: GSColorTokens.textPrimary,
            )
          : null,
    );
  }
}
