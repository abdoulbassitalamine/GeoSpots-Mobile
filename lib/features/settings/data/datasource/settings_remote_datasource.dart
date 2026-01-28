import 'package:geo_spots/features/settings/data/datasource/settings_remote_datasource_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsRemoteDatasourceProvider = Provider<SettingsRemoteDatasource>(
  (ref) => SettingsRemoteDatasourceImpl(),
);

abstract interface class SettingsRemoteDatasource {}