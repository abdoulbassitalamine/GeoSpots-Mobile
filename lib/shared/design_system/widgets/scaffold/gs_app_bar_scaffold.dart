import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';
import '../buttons/gs_back_button.dart';

class GSAppBarScaffold extends StatelessWidget {
  const GSAppBarScaffold({
    super.key,
    required this.title,
    required this.child,
    this.padding = GSSpacing.xl,
    this.onRefresh,
  });

  final String title;
  final Widget child;
  final double padding;
  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          snap: false,
          centerTitle: false,
          automaticallyImplyLeading: false,
          leadingWidth: leadingWidth,
          leading: Navigator.of(context).canPop() ? const GSBackButton() : null,
          iconTheme: const IconThemeData(color: GSColorTokens.textInverse),
          backgroundColor: GSColors.primary600,
          title: Text(
            title,
            style: GSTypography.headingSmall.copyWith(
              color: GSColorTokens.textInverse,
              fontWeight: FontWeight.w600,
              fontSize: GSFontScale.sf07
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GSColorTokens.primaryGradientVertical,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: child,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: GSColorTokens.backgroundPrimary,
        body: onRefresh == null
            ? scrollView
            : ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  physics: const BouncingScrollPhysics(),
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
                    await onRefresh?.call();
                  },
                  child: scrollView,
                ),
              ),
      ),
    );
  }
}
