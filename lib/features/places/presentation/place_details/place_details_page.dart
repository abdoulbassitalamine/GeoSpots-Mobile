import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../view_model/place_details_view_model.dart';
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
    final state = ref.watch(placeDetailsViewModelProvider(placeId));

    return PopScope<bool?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.of(
          context,
        ).pop(result ?? (state.shouldRefreshParent ? true : null));
      },
      child: Scaffold(
        body: PlaceDetailsView(placeId: placeId, readOnly: readOnly),
      ),
    );
  }
}
