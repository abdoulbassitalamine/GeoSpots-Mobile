import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/shared/design_system/widgets/logo/logo_min.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomeView extends HookConsumerWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = useState<bool>(false);

    useEffect(() {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => visible.value = true,
      );
      return null;
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: visible.value ? 1 : 0,
            duration: const Duration(seconds: 1),
            child: const Column(children: [LogoMin()]),
          ),
        ],
      ),
    );
  }
}
