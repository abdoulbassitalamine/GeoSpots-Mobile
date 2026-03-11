import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppDataSyncNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void notifyChanged() {
    state++;
  }
}

final appDataSyncProvider = NotifierProvider<AppDataSyncNotifier, int>(
  AppDataSyncNotifier.new,
);

void notifyAppDataChanged(Ref ref) {
  ref.read(appDataSyncProvider.notifier).notifyChanged();
}
