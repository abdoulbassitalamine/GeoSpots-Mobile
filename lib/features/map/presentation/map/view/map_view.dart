import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapView extends ConsumerWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child: Text('This is the Map page'));
  }
}
