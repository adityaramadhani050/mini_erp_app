import 'package:dartz/dartz.dart';
import 'package:mini_erp_app/core/failures/failure.dart';
import 'package:mini_erp_app/core/params/params.dart';
import 'package:mini_erp_app/core/usecases/usecase.dart';
import 'package:mini_erp_app/proposals/domain/entities/quotation.dart';
import 'package:mini_erp_app/proposals/domain/repositories/proposal_repository.dart';

class GetQuotationByID implements UseCase<Quotation, IDParams> {
  ProposalRepository<Quotation> repository;

  GetQuotationByID(this.repository);

  @override
  Future<Either<Failure, Quotation>> call(IDParams params) async {
    return await repository.getPropoposalById(params.id);
  }
}
