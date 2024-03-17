abstract class LocalDatasource {
  Future<List<dynamic>> getCacheMemory(String key);
  Future<bool> cacheData(String key, List<dynamic> data);
}
