abstract class ISecureStorage {
  Future<void> setData({required String key, required dynamic value});
  Future<String?> getData(String key);
  Future<void> removeData(String key);
  Future<void> clean();
}
