import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'view/place_details_view.dart';

class PlaceDetailsPage extends ConsumerWidget {
  final String placeId;

  const PlaceDetailsPage({super.key, required this.placeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PlaceDetailsView(placeId: placeId),
    );
  }
}