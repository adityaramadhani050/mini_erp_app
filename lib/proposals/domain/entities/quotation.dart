import 'proposal.dart';

class Quotation extends Proposal {
  const Quotation({
    required super.id,
    required super.name,
    required super.statusId,
    required super.customerId,
    required super.ammount,
    required super.createdDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        statusId,
        customerId,
        ammount,
        createdDate,
        expiredDate,
      ];
}
