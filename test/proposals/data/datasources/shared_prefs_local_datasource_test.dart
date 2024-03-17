import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_erp_app/core/exceptions/exception.dart';
import 'package:mini_erp_app/proposals/data/datasources/shared_prefs_local_datasource.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences sharedPreferences = MockSharedPreferences();
  SharedPrefsLocalDatasource datasource =
      SharedPrefsLocalDatasource(sharedPreferences);

  String testResponse = fixtureReader('quotations');
  List<dynamic> jsonDataTest = jsonDecode(testResponse);
  String key = 'quotations';

  test('should return list data from cache memory', () async {
    when(() => sharedPreferences.getString(key)).thenReturn(testResponse);

    final result = await datasource.getCacheMemory(key);

    expect(result, jsonDataTest);
    verify(() => sharedPreferences.getString(key));
  });

  test('should throw exception when cache is null', () {
    when(() => sharedPreferences.getString(key)).thenReturn(null);

    expect(() => datasource.getCacheMemory(key),
        throwsA(const TypeMatcher<CacheException>()));
    verify(() => sharedPreferences.getString(key));
    verifyNoMoreInteractions(sharedPreferences);
  });

  test('should return true when success save data', () async {
    when(() => sharedPreferences.setString(key, any()))
        .thenAnswer((_) async => Future.value(true));

    final result = await datasource.cacheData(key, jsonDataTest);

    expect(result, true);
    verify(() => sharedPreferences.setString(key, any()));
  });
}
