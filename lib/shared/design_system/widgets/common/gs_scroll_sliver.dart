import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';

class GSScrollSliver extends StatefulWidget {
  const GSScrollSliver({
    super.key,
    required this.title,
    required this.child,
    required this.onRefresh,
    this.onTitleTap,
    this.showMenuButton = false,
    this.onMenuPressed,
  });

  final String title;
  final Widget child;
  final RefreshCallback onRefresh;
  final VoidCallback? onTitleTap;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;

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

  Future<void> _scrollToTop() async {
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleTitleTap() {
    _scrollToTop();
    widget.onTitleTap?.call();
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
            if (await Vibration.hasVibrator()) {
              unawaited(Vibration.vibrate(duration: 50, amplitude: 50));
            }
            await widget.onRefresh();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                centerTitle: true,
                backgroundColor: GSColorTokens.backgroundSecondaryInverse,
                flexibleSpace: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleTitleTap,
                  child: SafeArea(
                    child: Center(
                      child: Text(
                        widget.title,
                        style: GSTypography.headingSmall.copyWith(
                          color: GSColorTokens.textInverse,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                leading: widget.showMenuButton
                    ? Builder(
                        builder: (context) {
                          return IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: GSColorTokens.textInverse,
                            ),
                            onPressed:
                                widget.onMenuPressed ??
                                () => Scaffold.of(context).openDrawer(),
                          );
                        },
                      )
                    : null,
              ),
              SliverToBoxAdapter(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
