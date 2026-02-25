import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_datasource.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferencesDataSource(Ref ref) =>
    throw UnimplementedError();
