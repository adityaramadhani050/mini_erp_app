import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_erp_app/core/failures/failure.dart';
import 'package:mini_erp_app/core/params/params.dart';
import 'package:mini_erp_app/proposals/domain/entities/quotation.dart';
import 'package:mini_erp_app/proposals/domain/usecase/get_quotations.dart';
import 'package:mini_erp_app/proposals/presentation/bloc/quotation_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetQuotations extends Mock implements GetQuotations {}

void main() {
  MockGetQuotations getQuotations = MockGetQuotations();
  QuotationBloc bloc = QuotationBloc(getQuotations);

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

  tearDown(() {
    bloc.close();
  });

  test('should state is initialstate', () {
    expect(bloc.state, equals(QuotationInitialState()));
  });

  blocTest(
    'should emit loading state and loaded state',
    build: () => bloc,
    setUp: () => when(() => getQuotations(NoParams()))
        .thenAnswer((_) async => Right(quotationsTest)),
    act: (bloc) => bloc.add(GetQuotationsEvent()),
    expect: () => [
      QuotationLoadingState(),
      QuotationsLoadedState(quotationsTest),
    ],
    verify: (bloc) => bloc.getQuotations,
  );

  blocTest(
    'should emit loading state and error state',
    build: () => bloc,
    setUp: () => when(() => getQuotations(NoParams()))
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure'))),
    act: (bloc) => bloc.add(GetQuotationsEvent()),
    expect: () => [
      QuotationLoadingState(),
      const QuotationErrorState(ServerFailure('Server Failure'))
    ],
    verify: (bloc) => bloc.getQuotations,
  );
}
