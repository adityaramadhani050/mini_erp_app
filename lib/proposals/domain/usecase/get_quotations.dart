import 'package:dartz/dartz.dart';
import 'package:mini_erp_app/core/params/params.dart';

import '../../../core/failures/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/quotation.dart';
import '../repositories/proposal_repository.dart';

class GetQuotations implements UseCase<List<Quotation>, NoParams> {
  ProposalRepository<Quotation> repository;

  GetQuotations(this.repository);

  @override
  Future<Either<Failure, List<Quotation>>> call(NoParams _) async {
    return await repository.getProposals();
  }
}
