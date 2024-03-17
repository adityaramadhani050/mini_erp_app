import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'proposals/domain/usecase/get_quotations.dart';
import 'proposals/injection_container.dart';
import 'proposals/presentation/bloc/quotation_bloc.dart';
import 'proposals/presentation/pages/proposal_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini ERP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: BlocProvider<QuotationBloc>(
        create: (context) => QuotationBloc(locator<GetQuotations>()),
        child: const ProposalPage(),
      ),
    );
  }
}
