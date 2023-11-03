import 'package:get_it/get_it.dart';
import 'package:timer_app/services/storage_service/shared_preferences_storage.dart';
import 'package:timer_app/services/storage_service/storage_service.dart';
import 'package:timer_app/pages/timer_page/timer_page_logic.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // state management layer
  getIt.registerLazySingleton<TimerPageManager>(() => TimerPageManager());

  // service layer
  getIt.registerLazySingleton<StorageService>(() => SharedPreferencesStorage());
}
