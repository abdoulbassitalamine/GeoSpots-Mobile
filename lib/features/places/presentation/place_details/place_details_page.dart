import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'view/place_details_view.dart';

class PlaceDetailsPage extends ConsumerWidget {
  const PlaceDetailsPage({
    super.key,
    required this.placeId,
    this.readOnly = false,
  });
  final String placeId;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PlaceDetailsView(placeId: placeId, readOnly: readOnly),
    );
  }
}
