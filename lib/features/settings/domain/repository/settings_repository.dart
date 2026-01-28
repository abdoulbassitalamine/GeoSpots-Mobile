import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository/settings_repository_impl.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(),
);

abstract interface class SettingsRepository {}
