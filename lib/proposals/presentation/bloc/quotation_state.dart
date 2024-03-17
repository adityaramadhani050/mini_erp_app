part of 'quotation_bloc.dart';

sealed class QuotationState extends Equatable {
  const QuotationState();

  @override
  List<Object> get props => [];
}

final class QuotationInitialState extends QuotationState {}

final class QuotationLoadingState extends QuotationState {}

final class QuotationsLoadedState extends QuotationState {
  final List<Quotation> quotations;

  const QuotationsLoadedState(this.quotations);

  @override
  List<Object> get props => [quotations];
}

final class QuotationErrorState extends QuotationState {
  final Failure failure;

  const QuotationErrorState(this.failure);

  @override
  List<Object> get props => [failure];
}
