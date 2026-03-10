import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_spots/core/utils/utils/debounce.dart';
import 'package:geo_spots/features/places/presentation/view_model/upsert_place_state.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../shared/design_system/design_system.dart';
import '../../view_model/upsert_place_view_model.dart';

part 'upsert_place_location_step_location_section.dart';
part 'upsert_place_location_step_manual_coordinates.dart';
part 'upsert_place_location_step_map.dart';
part 'upsert_place_location_step_tags.dart';

class UpsertPlaceLocationStepView extends HookWidget {
  const UpsertPlaceLocationStepView({
    super.key,
    required this.state,
    required this.notifier,
  });

  final UpsertPlaceState state;
  final UpsertPlaceViewModel notifier;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.position == null && !state.isLoading && state.isCreateMode) {
          notifier.getCurrentPosition();
        }
      });
      return null;
    }, const []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(),
        const SizedBox(height: GSSpacing.xl3),
        _LocationSection(
          state: state,
          notifier: notifier,
          position: state.position,
          isLoading: state.isLoading,
          onSetPosition: notifier.setPosition,
          onGetCurrentPosition: () =>
              notifier.getCurrentPosition(showLoading: false),
        ),
        const SizedBox(height: GSSpacing.xl3),
        _TagsSection(
          tags: state.tags,
          onTagsChanged: (newTags) {
            notifier.updateState(state.copyWith(tags: newTags));
          },
        ),
      ],
    );
  }
}
