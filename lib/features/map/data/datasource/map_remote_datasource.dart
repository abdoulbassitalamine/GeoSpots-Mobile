import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'map_remote_datasource_impl.dart';

final mapRemoteDatasourceProvider = Provider<MapRemoteDatasource>(
  (ref) => MapRemoteDatasourceImpl(),
);

abstract interface class MapRemoteDatasource {}
