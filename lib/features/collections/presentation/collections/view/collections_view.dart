import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionsView extends ConsumerWidget {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child: Text('This is the Collections page'));
  }
}
