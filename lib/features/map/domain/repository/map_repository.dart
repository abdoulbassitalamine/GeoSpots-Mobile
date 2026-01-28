import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository/map_repository_impl.dart';

final mapRepositoryProvider = Provider<MapRepository>(
  (ref) => MapRepositoryImpl(),
);

abstract interface class MapRepository {}
