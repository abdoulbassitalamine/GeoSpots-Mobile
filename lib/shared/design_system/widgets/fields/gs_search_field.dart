import 'package:flutter/material.dart';
import 'gs_text_field.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';

const _kExpanded = 'expanded';
const _kCollapsed = 'collapsed';

class GSSearchField extends StatefulWidget {
  const GSSearchField({
    super.key,
    required this.title,
    this.hintText,
    this.onChanged,
    this.onClear,
    this.onBack,
    this.controller,
    this.initialExpanded = false,
    this.collapsePadding,
    this.expandedPadding,
  });

  final String title;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final TextEditingController? controller;
  final bool initialExpanded;
  final EdgeInsetsGeometry? collapsePadding;
  final EdgeInsetsGeometry? expandedPadding;

  @override
  State<GSSearchField> createState() => _GSSearchFieldState();
}

class _GSSearchFieldState extends State<GSSearchField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _isExpanded;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _isExpanded = widget.initialExpanded;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
    if (_isExpanded) {
      widget.onChanged?.call(_controller.text);
    }
  }

  void _handleExpand() {
    setState(() {
      _isExpanded = true;
    });
    _focusNode.requestFocus();
  }

  void _handleBack() {
    setState(() {
      _isExpanded = false;
    });
    _controller.clear();
    widget.onBack?.call();
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GSSpacing.xl8,
      decoration: BoxDecoration(color: GSColorTokens.backgroundSecondary),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isExpanded
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
            widget.collapsePadding ??
            const EdgeInsets.symmetric(horizontal: GSSpacing.xl),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
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

    return GSTextField(
      key: const ValueKey(_kExpanded),
      maxLines: 1,
      focusBorder: border,
      enabledBorder: border,
      controller: _controller,
      focusNode: _focusNode,
      placeholder: widget.hintText,
      hintStyle: textStyle,
      inputStyle: textStyle,
      leadingIcon: IconButton(
        onPressed: _handleBack,
        icon: const Icon(Icons.arrow_back),
        color: GSColorTokens.textPrimary,
      ),
      trailingIcon: _hasText
          ? IconButton(
              onPressed: _handleClear,
              icon: const Icon(Icons.close),
              color: GSColorTokens.textPrimary,
            )
          : null,
    );
  }
}
