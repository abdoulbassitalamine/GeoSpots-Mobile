import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home_remote_datasource_impl.dart';

final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>(
  (ref) => HomeRemoteDatasourceImpl(),
);

abstract interface class HomeRemoteDatasource {}