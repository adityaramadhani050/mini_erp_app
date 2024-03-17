import 'package:equatable/equatable.dart';

abstract class Proposal extends Equatable {
  final int id;
  final String name;
  final int statusId;
  final int customerId;
  final int ammount;
  final DateTime createdDate;

  const Proposal({
    required this.id,
    required this.name,
    required this.statusId,
    required this.customerId,
    required this.ammount,
    required this.createdDate,
  });

  DateTime get expiredDate => DateTime(
        createdDate.year,
        createdDate.month,
        createdDate.day + 7,
      );
}
