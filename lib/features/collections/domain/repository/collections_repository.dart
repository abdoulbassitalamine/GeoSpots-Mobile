import 'package:geo_spots/features/collections/data/repository/collections_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionsRepositoryProvider = Provider<CollectionsRepository>(
  (ref) => CollectionsRepositoryImpl(),
);

abstract interface class CollectionsRepository {}
