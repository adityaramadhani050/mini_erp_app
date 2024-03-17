import 'proposal.dart';
import 'quotation.dart';

class Invoice extends Proposal {
  final String title;
  final double termin;
  final Quotation quotation;

  Invoice({
    required int id,
    required this.title,
    required this.termin,
    required int statusId,
    required DateTime createdDate,
    required this.quotation,
  }) : super(
          id: id,
          name: '$title - ${quotation.name}',
          statusId: statusId,
          customerId: quotation.customerId,
          ammount: (quotation.ammount * termin).toInt(),
          createdDate: createdDate,
        );

  @override
  List<Object?> get props => [
        title,
        termin,
        quotation,
        id,
        name,
        statusId,
        customerId,
        ammount,
        createdDate
      ];
}
