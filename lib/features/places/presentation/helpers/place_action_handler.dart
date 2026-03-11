import 'package:flutter/material.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/entity/place_entity.dart';
import '../../domain/use_case/places_use_cases.dart';
import '../place_details/wigets/navigation_options_dialog.dart';

class PlaceActionHandler {
  const PlaceActionHandler._();

  static Future<void> openDirections(
    BuildContext context, {
    required PlaceEntity place,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) => NavigationOptionsDialog(place: place),
    );
  }

  static Future<void> share(
    BuildContext context,
    WidgetRef ref, {
    required PlaceEntity place,
  }) async {
    final sharePlace = ref.read(sharePlaceUseCaseProvider);
    final result = await sharePlace(id: place.id, canWrite: false);

    switch (result) {
      case Ok(value: final value):
        final shareText = StringBuffer()
          ..writeln(place.title)
          ..writeln(value.url);
        if (value.expiresAt != null) {
          shareText.writeln('Expire le ${_formatDate(value.expiresAt!)}');
        }

        await SharePlus.instance.share(
          ShareParams(
            subject: 'Partage du lieu: ${place.title}',
            text: shareText.toString(),
          ),
        );
      case Err():
        if (context.mounted) {
          GSScaffoldSnackbar.showError(
            context,
            message: 'Impossible de partager ce lieu',
          );
        }
    }
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
