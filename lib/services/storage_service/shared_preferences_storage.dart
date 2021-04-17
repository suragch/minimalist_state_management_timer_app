import 'package:shared_preferences/shared_preferences.dart';

import 'storage_service.dart';

class SharedPreferencesStorage extends StorageService {

  static const time_left_key = 'time_left';
  @override
  Future<int?> getTimeLeft() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(time_left_key);
  }

  @override
  Future<void> saveTimeLeft(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(time_left_key, seconds);
  }
}