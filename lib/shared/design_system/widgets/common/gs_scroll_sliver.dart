import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/color_tokens.dart';

class GSScrollSliver extends StatefulWidget {
  const GSScrollSliver({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final RefreshCallback onRefresh;

  @override
  State<GSScrollSliver> createState() => _GSScrollSliverState();
}

class _GSScrollSliverState extends State<GSScrollSliver> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: RefreshIndicator(
          color: GSColorTokens.textInverse,
          backgroundColor: GSColorTokens.textAccent,
          onRefresh: () async {
            await HapticFeedback.lightImpact();
            await widget.onRefresh();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [SliverToBoxAdapter(child: widget.child)],
          ),
        ),
      ),
    );
  }
}
