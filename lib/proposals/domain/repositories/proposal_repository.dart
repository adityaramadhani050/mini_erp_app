import 'package:dartz/dartz.dart';
import '../../../core/failures/failure.dart';

abstract class ProposalRepository<ProposalType> {
  Future<Either<Failure, List<ProposalType>>> getProposals();
  Future<Either<Failure, ProposalType>> getPropoposalById(int id);
}
