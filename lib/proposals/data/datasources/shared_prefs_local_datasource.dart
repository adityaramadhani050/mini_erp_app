import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/exceptions/exception.dart';
import 'local_datasource.dart';

class SharedPrefsLocalDatasource implements LocalDatasource {
  final SharedPreferences sharedPreferences;

  SharedPrefsLocalDatasource(this.sharedPreferences);

  @override
  Future<bool> cacheData(String key, List<dynamic> data) async {
    bool isSuccess = await sharedPreferences.setString(key, jsonEncode(data));

    return Future.value(isSuccess);
  }

  @override
  Future<List> getCacheMemory(String key) {
    String? cacheData = sharedPreferences.getString(key);

    if (cacheData != null) {
      List<dynamic> data = jsonDecode(cacheData);
      return Future.value(data);
    } else {
      throw CacheException(message: 'Invalid key/data is null');
    }
  }
}
