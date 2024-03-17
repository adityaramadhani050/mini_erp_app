import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../core/exceptions/exception.dart';
import '../../../core/failures/failure.dart';
import '../../domain/entities/quotation.dart';
import '../../domain/repositories/proposal_repository.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/quotation_model.dart';

class QuotationRepository implements ProposalRepository<Quotation> {
  final RemoteDatasource remoteDatasource;
  final LocalDatasource localDatasource;
  final InternetConnectionChecker connectionChecker;

  final String _url =
      'https://my-json-server.typicode.com/ramanozawa/renus-sales/quotations';

  QuotationRepository({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, Quotation>> getPropoposalById(int id) async {
    if (await connectionChecker.hasConnection) {
      try {
        final jsonResponse = await remoteDatasource.fetchData('$_url/$id');

        return Right(QuotationModel.fromJson(jsonResponse).toQuotation());
      } on ServerException catch (error) {
        return Left(
            ServerFailure('Server Failure: ${error.message} ID Not Found'));
      }
    } else {
      try {
        final jsonResponse =
            await localDatasource.getCacheMemory('LAST-QUOTATIONS');

        return Right(
            QuotationModel.fromJson(jsonResponse[id - 1]).toQuotation());
      } on CacheException catch (error) {
        return Left(CacheFailure('Cache Failure: ${error.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Quotation>>> getProposals() async {
    if (await connectionChecker.hasConnection) {
      try {
        final jsonResponse = await remoteDatasource.fetchData(_url);

        await localDatasource.cacheData('LAST-QUOTATIONS', jsonResponse);

        return Right(_jsonListConverter(jsonResponse));
      } on ServerException catch (error) {
        return Left(ServerFailure('Server Failure: ${error.message}'));
      }
    } else {
      try {
        final jsonResponse =
            await localDatasource.getCacheMemory('LAST-QUOTATIONS');

        return Right(_jsonListConverter(jsonResponse));
      } on CacheException catch (error) {
        return Left(CacheFailure('Cache Failure: ${error.message}'));
      }
    }
  }

  List<Quotation> _jsonListConverter(dynamic jsonResponse) {
    List<Quotation> quotations = [];
    for (Map<String, dynamic> json in jsonResponse) {
      quotations.add(QuotationModel.fromJson(json).toQuotation());
    }
    return quotations;
  }
}
