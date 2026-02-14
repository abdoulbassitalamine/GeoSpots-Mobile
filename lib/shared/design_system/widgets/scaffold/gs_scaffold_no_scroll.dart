import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';
import '../buttons/gs_back_button.dart';

class GSScaffoldNoScroll extends StatelessWidget {
  const GSScaffoldNoScroll({
    super.key,
    required this.title,
    required this.child,
    this.padding = GSSpacing.xl,
    this.drawer,
    this.actions,
  });

  final Widget child;
  final String title;
  final double padding;
  final Widget? drawer;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: GSColorTokens.backgroundPrimary,
          drawer: drawer,
          body: Column(
            children: [
              Container(
                height: GSSpacing.xl,
                color: GSColorTokens.backgroundAccent,
              ),
              AppBar(
                centerTitle: false,
                leadingWidth: leadingWidth,
                leading: const GSBackButton(),
                iconTheme: IconThemeData(color: GSColorTokens.textInverse),
                foregroundColor: GSColorTokens.backgroundPrimary,
                backgroundColor: GSColorTokens.backgroundAccent,
                title: Text(
                  title,
                  style: GSTypography.headingSmall.copyWith(
                    color: GSColorTokens.textInverse,
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
