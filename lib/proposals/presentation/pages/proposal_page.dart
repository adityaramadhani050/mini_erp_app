import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quotation_bloc.dart';

class ProposalPage extends StatelessWidget {
  const ProposalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Proposal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(child: Center(
            child: BlocBuilder<QuotationBloc, QuotationState>(
              builder: (context, state) {
                if (state is QuotationInitialState) {
                  return const Text('Ready Get Data');
                } else if (state is QuotationLoadingState) {
                  return const CircularProgressIndicator();
                } else if (state is QuotationsLoadedState) {
                  return Text('${state.quotations}');
                } else if (state is QuotationErrorState) {
                  return Text(
                    state.failure.message,
                    style: const TextStyle(color: Colors.red),
                  );
                } else {
                  return const Text('Proposal');
                }
              },
            ),
          )),
          Expanded(
              child: Center(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<QuotationBloc>(context)
                    .add(GetQuotationsEvent());
              },
              child: const Text('Get Data'),
            ),
          )),
        ],
      ),
    );
  }
}
