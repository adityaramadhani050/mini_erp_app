import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_erp_app/core/failures/failure.dart';
import 'package:mini_erp_app/core/params/params.dart';
import 'package:mini_erp_app/proposals/domain/entities/quotation.dart';
import 'package:mini_erp_app/proposals/domain/usecase/get_quotation_by_id.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/mock_proposal_repository.dart';

void main() {
  MockQuotationProposalRepository repository =
      MockQuotationProposalRepository();

  GetQuotationByID usecase = GetQuotationByID(repository);

  Quotation quotationTest = Quotation(
    id: 1,
    name: 'test',
    statusId: 1,
    customerId: 1,
    ammount: 10,
    createdDate: DateTime.now(),
  );

  test('should return quotation by id', () async {
    when(() => repository.getPropoposalById(1))
        .thenAnswer((_) async => Right(quotationTest));

    final result = await usecase(IDParams(1));

    expect(result, equals(Right(quotationTest)));
    verify(() => repository.getPropoposalById(1));
  });

  test('should return failure', () async {
    when(() => repository.getPropoposalById(1))
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

    final result = await usecase(IDParams(1));
    expect(result, equals(const Left(ServerFailure('Server Failure'))));
    verify(() => repository.getPropoposalById(1));
  });
}
