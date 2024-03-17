part of 'quotation_bloc.dart';

sealed class QuotationEvent extends Equatable {
  const QuotationEvent();

  @override
  List<Object> get props => [];
}

final class GetQuotationsEvent extends QuotationEvent {}

final class GetQuotationByIDEvent extends QuotationEvent {
  final int id;

  const GetQuotationByIDEvent(this.id);

  @override
  List<Object> get props => [id];
}
