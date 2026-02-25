import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/color_tokens.dart';

class GSSingleScroll extends StatelessWidget {
  const GSSingleScroll({
    super.key,
    required this.child,
    required this.onRefresh,
    this.controller,
    this.padding,
  });

  final Widget child;
  final RefreshCallback onRefresh;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return RefreshIndicator(
              color: GSColorTokens.textInverse,
              backgroundColor: GSColorTokens.textAccent,
              onRefresh: () async {
                await HapticFeedback.lightImpact();
                await onRefresh();
              },
              child: SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: padding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
