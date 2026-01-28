import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../tokens/color_tokens.dart';

class GSRefreshScaffold extends StatelessWidget {
  const GSRefreshScaffold({
    super.key,
    required this.child,
    this.onRefresh,
    this.backgroundColor,
    this.padding,
    this.enableRefresh = true,
  });

  final Widget child;
  final Future<void> Function()? onRefresh;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final bool enableRefresh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor ?? GSColorTokens.backgroundPrimary,
        body: Padding(
          padding: padding ?? const EdgeInsets.all(GSSpacing.xl),
          child: enableRefresh && onRefresh != null
              ? RefreshIndicator(
            color: GSColorTokens.textInverse,
            backgroundColor: GSColorTokens.textAccent,
            onRefresh: onRefresh!,
            child: child,
          )
              : child,
        ),
      ),
    );
  }
}