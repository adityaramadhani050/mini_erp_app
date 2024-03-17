import 'dart:convert';

import 'package:http/http.dart';

import '../../../core/exceptions/exception.dart';
import 'remote_datasource.dart';

class ApiRemoteDatasource implements RemoteDatasource {
  final Client client;

  ApiRemoteDatasource(this.client);

  @override
  Future<dynamic> fetchData(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      dynamic jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw ServerException(
          message: 'Cannot fetch data status code ${response.statusCode}');
    }
  }
}
