import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'collections_remote_datasource_impl.dart';

final collectionsRemoteDatasourceProvider = Provider<ICollectionsRemoteDatasource>(
  (ref) => CollectionsRemoteDatasourceImpl(),
);

abstract interface class ICollectionsRemoteDatasource {}
