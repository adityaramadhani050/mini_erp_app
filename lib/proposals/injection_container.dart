import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/api_remote_datasource.dart';
import 'data/datasources/shared_prefs_local_datasource.dart';
import 'data/repositories/quotation_repository.dart';
import 'domain/usecase/get_quotations.dart';
import 'presentation/bloc/quotation_bloc.dart';

GetIt locator = GetIt.instance;

Future<void> initInjection() async {
  //bloc
  locator.registerFactory<QuotationBloc>(
      () => QuotationBloc(locator<GetQuotations>()));

  //usecase
  locator.registerLazySingleton<GetQuotations>(
      () => GetQuotations(locator<QuotationRepository>()));

  //repository
  locator.registerLazySingleton<QuotationRepository>(() => QuotationRepository(
        remoteDatasource: locator<ApiRemoteDatasource>(),
        localDatasource: locator<SharedPrefsLocalDatasource>(),
        connectionChecker: locator<InternetConnectionChecker>(),
      ));

  //datasource
  locator.registerLazySingleton<ApiRemoteDatasource>(
      () => ApiRemoteDatasource(locator<Client>()));
  locator.registerLazySingleton<SharedPrefsLocalDatasource>(
      () => SharedPrefsLocalDatasource(locator<SharedPreferences>()));

  //external
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  locator.registerLazySingleton<Client>(() => Client());
  locator.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
