abstract class ILocalStorage {
  Future<bool> setData({required final String key, final dynamic value});
  Future<dynamic> getData(String key);
  Future<bool> removeData(String key);
  Future<bool> clean();
}
