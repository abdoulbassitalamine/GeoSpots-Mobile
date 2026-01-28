import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository/home_repository_impl.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(),
);

abstract interface class HomeRepository {}
