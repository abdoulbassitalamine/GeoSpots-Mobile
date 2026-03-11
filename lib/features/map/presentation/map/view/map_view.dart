import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:geo_spots/features/map/presentation/view_model/map_view_model.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/places/presentation/place_details/wigets/navigation_options_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../widgets/map_floating_controls.dart';
import '../widgets/map_marker_dot.dart';
import '../widgets/map_place_preview_card.dart';
import '../widgets/map_place_search_delegate.dart';
import '../widgets/map_top_panel.dart';

class MapView extends HookConsumerWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationStatus = ref.watch(authGuardProvider);
    final isAuthenticated =
        authenticationStatus is AuthenticationStatusAuthenticated;
    final state = ref.watch(mapViewModelProvider);
    final notifier = ref.read(mapViewModelProvider.notifier);
    final mapController = useMemoized(MapController.new);
    final isMapReady = useState(false);
    final isPreviewVisible = useState(true);
    final isShareInfoVisible = useState(true);
    final isSearchMode = state.searchQuery.trim().isNotEmpty;
    final hasSecondaryTopCard =
        !isSearchMode && (isAuthenticated || isShareInfoVisible.value);

    ref.listen<AuthenticationStatus>(authGuardProvider, (
      AuthenticationStatus? previous,
      AuthenticationStatus next,
    ) {
      if (previous?.runtimeType != next.runtimeType) {
        notifier.loadPlaces();
      }
    });

    final allMappedPlaces = _mapPlacesToPreview(state.allPlaces);
    final visibleMappedPlaces = _mapPlacesToPreview(state.visiblePlaces);

    final categories = state.categories
        .map<(String, IconData)>((category) => (category, Icons.label_outline))
        .toList();

    final initialCenter = allMappedPlaces.isNotEmpty
        ? allMappedPlaces.first.point
        : const LatLng(48.8566, 2.3522);

    final selectedPlace = visibleMappedPlaces.isEmpty
        ? null
        : _resolveSelectedPlace(
            places: visibleMappedPlaces,
            selectedPlaceId: state.selectedPlaceId,
          );

    final safeIndex = selectedPlace == null
        ? -1
        : visibleMappedPlaces.indexWhere(
            (place) => place.place.id == selectedPlace.place.id,
          );

    useEffect(() {
      if (!isMapReady.value) {
        return null;
      }
      mapController.move(
        selectedPlace?.point ?? initialCenter,
        mapController.camera.zoom,
      );
      return null;
    }, [isMapReady.value, selectedPlace?.place.id, initialCenter]);

    useEffect(() {
      if (selectedPlace != null) {
        isPreviewVisible.value = true;
      }
      return null;
    }, [selectedPlace?.place.id]);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [GSColors.primary100, GSColors.primary200],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: 6.8,
                minZoom: 3,
                maxZoom: 19,
                onMapReady: () => isMapReady.value = true,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.geo_spots',
                ),
                MarkerLayer(
                  markers: [
                    for (int i = 0; i < visibleMappedPlaces.length; i++)
                      Marker(
                        point: visibleMappedPlaces[i].point,
                        width: 24,
                        height: 24,
                        child: MapMarkerDot(
                          isSelected: i == safeIndex,
                          onTap: () {
                            notifier.selectPlace(
                              visibleMappedPlaces[i].place.id,
                            );
                            isPreviewVisible.value = true;
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (state.isLoading)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                minHeight: 2,
                color: GSColors.primary500,
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                GSSpacing.xl,
                GSSpacing.xl,
                GSSpacing.xl,
                GSSpacing.xl,
              ),
              child: SizedBox.expand(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MapTopPanel(
                          isAuthenticated: isAuthenticated,
                          isShareInfoVisible: isShareInfoVisible.value,
                          isSearchMode: isSearchMode,
                          searchQuery: state.searchQuery,
                          selectedCategory: state.selectedCategory,
                          categories: categories,
                          onSearchTap: () async {
                            final selection =
                                await showSearch<MapPlaceSearchSelection?>(
                                  context: context,
                                  delegate: MapPlaceSearchDelegate(
                                    places: state.allPlaces,
                                    currentCenter: isMapReady.value
                                        ? mapController.camera.center
                                        : initialCenter,
                                    initialQuery: state.searchQuery,
                                  ),
                                );
                            if (selection == null) {
                              return;
                            }
                            notifier.updateSearchQuery(selection.query);
                            if (selection.placeId != null) {
                              notifier.selectPlace(selection.placeId!);
                              isPreviewVisible.value = true;
                            }
                          },
                          onDismissShareInfo: () {
                            isShareInfoVisible.value = false;
                          },
                          onClearSearch: () => notifier.updateSearchQuery(''),
                          onCategorySelected: notifier.selectCategory,
                        ),
                      ],
                    ),
                    Positioned(
                      top: hasSecondaryTopCard ? 176 : 88,
                      right: 0,
                      child: MapFloatingControls(
                        onCenterTap: () {
                          if (!isMapReady.value) return;
                          mapController.move(
                            selectedPlace?.point ?? initialCenter,
                            14.8,
                          );
                        },
                        onZoomInTap: () {
                          if (!isMapReady.value) return;
                          final nextZoom = (mapController.camera.zoom + 0.8)
                              .clamp(3.0, 19.0)
                              .toDouble();
                          mapController.move(
                            mapController.camera.center,
                            nextZoom,
                          );
                        },
                        onZoomOutTap: () {
                          if (!isMapReady.value) return;
                          final nextZoom = (mapController.camera.zoom - 0.8)
                              .clamp(3.0, 19.0)
                              .toDouble();
                          mapController.move(
                            mapController.camera.center,
                            nextZoom,
                          );
                        },
                      ),
                    ),
                    if (isPreviewVisible.value && selectedPlace != null)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: MapPlacePreviewCard(
                          place: selectedPlace,
                          compact: state.searchQuery.trim().isNotEmpty,
                          onDirectionsTap: () {
                            if (!selectedPlace.place.hasCoordinates) {
                              return;
                            }
                            showDialog<void>(
                              context: context,
                              builder: (_) => NavigationOptionsDialog(
                                place: selectedPlace.place,
                              ),
                            );
                          },
                          onShareTap: () =>
                              notifier.sharePlace(selectedPlace.place.id),
                          onClose: () => isPreviewVisible.value = false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  MapPlacePreviewModel _resolveSelectedPlace({
    required List<MapPlacePreviewModel> places,
    required String? selectedPlaceId,
  }) {
    if (selectedPlaceId == null) {
      return places.first;
    }
    for (final place in places) {
      if (place.place.id == selectedPlaceId) {
        return place;
      }
    }
    return places.first;
  }

  List<MapPlacePreviewModel> _mapPlacesToPreview(List<PlaceEntity> places) {
    return places
        .where((place) => place.hasCoordinates)
        .map(
          (place) => MapPlacePreviewModel(
            place: place,
            title: place.title,
            subtitle: [
              place.city,
              place.country,
            ].where((value) => value != null && value.isNotEmpty).join(', '),
            category: place.tags.isNotEmpty ? place.tags.first : 'Sans tag',
            icon: Icons.place,
            point: LatLng(place.latitude!, place.longitude!),
          ),
        )
        .toList();
  }
}
