import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_erp_app/proposals/data/models/quotation_model.dart';
import 'package:mini_erp_app/proposals/domain/entities/quotation.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  QuotationModel quotationModel = QuotationModel(
    id: 1,
    name: 'test1',
    statusId: 1,
    customerId: 1,
    ammount: 1,
    createdDate: DateTime(2024, 2, 1),
  );

  String response = fixtureReader('quotations');
  Map<String, dynamic> json = jsonDecode(response)[0];

  test('should be sub of Quotation', () {
    expect(quotationModel, isA<Quotation>());
  });

  test('should convert from json to model', () {
    final result = QuotationModel.fromJson(json);
    expect(result, equals(quotationModel));
  });

  test('should convert from model to json', () {
    final result = quotationModel.toJson();
    expect(result, equals(json));
  });
}
