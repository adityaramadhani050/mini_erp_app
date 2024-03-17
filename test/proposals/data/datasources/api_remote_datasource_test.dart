import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mini_erp_app/core/exceptions/exception.dart';
import 'package:mini_erp_app/proposals/data/datasources/api_remote_datasource.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient client = MockClient();
  ApiRemoteDatasource datasource = ApiRemoteDatasource(client);

  String url =
      'https://my-json-server.typicode.com/ramanozawa/renus-sales/quotations';

  String testResponse = fixtureReader('quotations');
  List<dynamic> jsonDataTest = jsonDecode(testResponse);

  test('should return quotation model json when succes fetch data from api',
      () async {
    when(() => client.get(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer((_) async => http.Response(testResponse, 200));

    final result = await datasource.fetchData(url);

    expect(result, equals(jsonDataTest));
    verify(() => client.get(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        ));
  });

  test('should throw exception when status code not 200', () async {
    when(() => client
            .get(Uri.parse(url), headers: {'Content-Type': 'application/json'}))
        .thenAnswer((_) async => http.Response('{}', 404));

    expect(() => datasource.fetchData(url),
        throwsA(const TypeMatcher<ServerException>()));
    verify(() => client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'}));
    verifyNoMoreInteractions(client);
  });
}
