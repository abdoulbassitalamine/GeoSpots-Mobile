import 'package:flutter/material.dart';
import 'package:geo_spots/core/router/route_names.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/utils/extensions/sized_box_extension.dart';
import '../../view_model/home_view_model.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_recent_locations_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: HomeHeaderWidget(
            username: homeState.username,
            placesCount: homeState.totalLocations,
            collectionsCount: homeState.totalCollections,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: GSSpacing.$200),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                HomeRecentLocationsWidget(
                  recentPlaces: homeState.recentPlaces,
                ),
                GSContainerButton.filled(
                  onPressed: () {
                    context.pushNamed(RouteNames.addPlaceName);
                  },
                  text: 'Ajouter un lieu',
                  icon: Icons.add_circle_outline,
                  padding: EdgeInsets.symmetric(vertical: GSSpacing.$200),
                  gradient: GSColorTokens.primaryGradientHorizontal,
                ),
                GSSpacing.$300.toInt().toHeight,
              ],
            ),
          ),
        ),
      ],
    );
  }
}