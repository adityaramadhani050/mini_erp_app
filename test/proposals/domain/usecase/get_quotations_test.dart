import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_erp_app/core/failures/failure.dart';
import 'package:mini_erp_app/core/params/params.dart';
import 'package:mini_erp_app/proposals/domain/entities/quotation.dart';
import 'package:mini_erp_app/proposals/domain/usecase/get_quotations.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/mock_proposal_repository.dart';

void main() {
  MockQuotationProposalRepository repository =
      MockQuotationProposalRepository();

  GetQuotations usecase = GetQuotations(repository);

  List<Quotation> quotationsTest = [
    Quotation(
      id: 1,
      name: 'test',
      statusId: 1,
      customerId: 1,
      ammount: 10,
      createdDate: DateTime.now(),
    ),
    Quotation(
      id: 2,
      name: 'test',
      statusId: 2,
      customerId: 2,
      ammount: 10,
      createdDate: DateTime.now(),
    ),
  ];

  test('should return List<Quotation> when succesfull', () async {
    when(() => repository.getProposals())
        .thenAnswer((_) async => Right(quotationsTest));

    final result = await usecase(NoParams());

    expect(result, equals(Right(quotationsTest)));
  });

  test('should return Failure when unsuccess get data', () async {
    when(() => repository.getProposals())
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

    final result = await usecase(NoParams());

    expect(result, equals(const Left(ServerFailure('Server Failure'))));
    verify(() => repository.getProposals());
  });
}
