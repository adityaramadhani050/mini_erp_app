import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mini_erp_app/core/exceptions/exception.dart';
import 'package:mini_erp_app/core/failures/failure.dart';
import 'package:mini_erp_app/proposals/data/datasources/api_remote_datasource.dart';
import 'package:mini_erp_app/proposals/data/datasources/shared_prefs_local_datasource.dart';
import 'package:mini_erp_app/proposals/data/models/quotation_model.dart';
import 'package:mini_erp_app/proposals/data/repositories/quotation_repository.dart';
import 'package:mini_erp_app/proposals/domain/entities/quotation.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockApiRemoteDatasource extends Mock implements ApiRemoteDatasource {}

class MockSharedPrefsLocalDatasource extends Mock
    implements SharedPrefsLocalDatasource {}

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  MockApiRemoteDatasource remoteDatasource = MockApiRemoteDatasource();
  MockSharedPrefsLocalDatasource localDatasource =
      MockSharedPrefsLocalDatasource();
  MockInternetConnectionChecker internetConnectionChecker =
      MockInternetConnectionChecker();

  QuotationRepository quotationRepository = QuotationRepository(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
    connectionChecker: internetConnectionChecker,
  );

  List<Quotation> quotationsTest = [];

  String testResponse = fixtureReader('quotations');
  List<dynamic> jsonDataTest = jsonDecode(testResponse);

  for (Map<String, dynamic> jsonTest in jsonDataTest) {
    quotationsTest.add(QuotationModel.fromJson(jsonTest).toQuotation());
  }

  String url =
      'https://my-json-server.typicode.com/ramanozawa/renus-sales/quotations';
  String key = 'LAST-QUOTATIONS';

  group('online', () {
    test('should return List<Quotation> from API when succes fetch data>',
        () async {
      when(() => internetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      when(() => remoteDatasource.fetchData(url))
          .thenAnswer((_) async => jsonDataTest);
      when(() => localDatasource.cacheData(key, jsonDataTest))
          .thenAnswer((_) async => true);

      final result = await quotationRepository.getProposals();
      final data =
          result.fold((failure) => failure, (quotations) => quotations);

      expect(data, equals(quotationsTest));

      verify(() => remoteDatasource.fetchData(url));
      verify(() => internetConnectionChecker.hasConnection);
    });

    test('should cache data to local when succes fetch data>', () async {
      when(() => internetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      when(() => remoteDatasource.fetchData(url))
          .thenAnswer((_) async => jsonDataTest);
      when(() => localDatasource.cacheData(key, jsonDataTest))
          .thenAnswer((_) async => true);

      await quotationRepository.getProposals();

      verify(() => localDatasource.cacheData(key, jsonDataTest));
    });

    test('should return server failure from API when unsucces fetch data',
        () async {
      when(() => internetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      when(() => remoteDatasource.fetchData(url)).thenThrow(ServerException());
      when(() => localDatasource.cacheData(key, jsonDataTest))
          .thenAnswer((_) async => true);

      final result = await quotationRepository.getProposals();

      expect(
          result,
          equals(const Left<Failure, List<Quotation>>(
              ServerFailure('Server Failure: '))));
      verify(() => internetConnectionChecker.hasConnection);
      verify(() => remoteDatasource.fetchData(url));
      verifyNoMoreInteractions(remoteDatasource);
      verifyZeroInteractions(localDatasource);
    });
  });

  group('offline', () {
    test('should return List<Quotation> from local cache', () async {
      when(() => internetConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);
      when(() => localDatasource.getCacheMemory(key))
          .thenAnswer((_) async => jsonDataTest);

      final result = await quotationRepository.getProposals();
      final data =
          result.fold((failure) => failure, (quotations) => quotations);

      expect(data, equals(quotationsTest));

      verify(() => internetConnectionChecker.hasConnection);
      verify(() => localDatasource.getCacheMemory(key));
      verifyNoMoreInteractions(localDatasource);
      verifyZeroInteractions(remoteDatasource);
    });

    test('should return cache failure when unsucces get data from local',
        () async {
      when(() => internetConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);
      when(() => localDatasource.getCacheMemory(key))
          .thenThrow(CacheException());

      final result = await quotationRepository.getProposals();

      expect(
          result,
          equals(const Left<Failure, List<Quotation>>(
              CacheFailure('Cache Failure: '))));

      verify(() => internetConnectionChecker.hasConnection);
      verify(() => localDatasource.getCacheMemory(key));
      verifyNoMoreInteractions(localDatasource);
      verifyZeroInteractions(remoteDatasource);
    });
  });
}
