import '../../domain/entities/quotation.dart';

class QuotationModel extends Quotation {
  const QuotationModel({
    required super.id,
    required super.name,
    required super.statusId,
    required super.customerId,
    required super.ammount,
    required super.createdDate,
  });

  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    return QuotationModel(
      id: json['id'],
      name: json['name'],
      statusId: json['statusId'],
      customerId: json['customerId'],
      ammount: json['ammount'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'statusId': statusId,
      'customerId': customerId,
      'ammount': ammount,
      'createdDate': createdDate.toString(),
    };
  }

  Quotation toQuotation() {
    return Quotation(
      id: id,
      name: name,
      statusId: statusId,
      customerId: customerId,
      ammount: ammount,
      createdDate: createdDate,
    );
  }
}
