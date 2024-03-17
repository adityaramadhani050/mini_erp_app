import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_erp_app/core/params/params.dart';
import '../../../core/failures/failure.dart';
import '../../domain/entities/quotation.dart';
import '../../domain/usecase/get_quotations.dart';

part 'quotation_event.dart';
part 'quotation_state.dart';

class QuotationBloc extends Bloc<QuotationEvent, QuotationState> {
  GetQuotations getQuotations;

  QuotationBloc(this.getQuotations) : super(QuotationInitialState()) {
    on<GetQuotationsEvent>(_getQuotations);
    on<GetQuotationByIDEvent>(_getQuotationByID);
  }

  void _getQuotations(_, Emitter<QuotationState> emit) async {
    emit(QuotationLoadingState());

    final eitherData = await getQuotations(NoParams());

    eitherData.fold((failure) => emit(QuotationErrorState(failure)),
        (quotations) => emit(QuotationsLoadedState(quotations)));
  }

  void _getQuotationByID(_, Emitter<QuotationState> emit) async {}
}
