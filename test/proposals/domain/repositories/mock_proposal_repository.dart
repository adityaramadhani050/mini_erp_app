import 'package:mini_erp_app/proposals/domain/entities/quotation.dart';
import 'package:mini_erp_app/proposals/domain/repositories/proposal_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockQuotationProposalRepository extends Mock
    implements ProposalRepository<Quotation> {}
