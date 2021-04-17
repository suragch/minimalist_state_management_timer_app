abstract class StorageService {
  Future<int?> getTimeLeft();
  Future<void> saveTimeLeft(int seconds);
}