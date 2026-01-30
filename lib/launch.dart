import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geo_spots/shared/storage/secure_storage/datasource/secure_storage_datasource.dart';
import 'package:geo_spots/shared/storage/shared_preferences/datasource/shared_preferences_datasource.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/logger/gs_logger.dart';

FutureOr<void> launch(String env) async {
  await runZonedGuarded<Future<void>>(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await dotenv.load(fileName: env);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
        ),
      );
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      FlutterNativeSplash.remove();

      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesDataSourceProvider.overrideWithValue(
              await SharedPreferences.getInstance(),
            ),
            secureStorageDataSourceProvider.overrideWith(
              (ref) => const FlutterSecureStorage(),
            ),
          ],
          child: const GeoSpots(),
        ),
      );
    },
    (error, stackTrace) {
      GsLogger().e(error.toString(), error, stackTrace);
    },
  );
}
