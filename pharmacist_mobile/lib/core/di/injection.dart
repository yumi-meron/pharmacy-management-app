import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:pharmacist_mobile/core/network/network_info.dart';
import 'package:pharmacist_mobile/data/datasources/auth_remote_data_source.dart';
import 'package:pharmacist_mobile/data/datasources/medicine_remote_data_source.dart';
import 'package:pharmacist_mobile/data/datasources/mock_auth_remote_data_source.dart';
import 'package:pharmacist_mobile/data/datasources/mock_medicine_remote_datasource.dart';
import 'package:pharmacist_mobile/data/repositories/auth_repository_impl.dart';
import 'package:pharmacist_mobile/data/repositories/medicine_repository_impl.dart';
import 'package:pharmacist_mobile/domain/repositories/auth_repository.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/sign_in.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/forgot_password.dart';
import 'package:pharmacist_mobile/domain/usecases/medicine/search_medicine.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setup() async {
  // External dependencies
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<http.Client>(http.Client());
  getIt.registerSingleton<InternetConnectionChecker>(InternetConnectionChecker.createInstance());
  

  // Core
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton(() => SearchMedicines(getIt()));

  // Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    RemoteDataSourceImpl(dio: getIt(), prefs: getIt()),
  );

  //Fake path
  // getIt.registerSingleton<AuthRemoteDataSource>(MockAuthRemoteDataSource());


  getIt.registerSingleton<MedicineRemoteDataSource>(MedicineRemoteDataSource(client: getIt(),prefs: getIt()));

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );


  //real path
  getIt.registerSingleton<MedicineRepository>(
    MedicineRepositoryImpl(dataSource: getIt(), networkInfo: getIt()),
  );
  //fake
  // getIt.registerSingleton<MedicineRepository>(MockMedicineRepository());


  
  // Use Cases
  getIt.registerSingleton<SignIn>(SignIn(getIt()));
  getIt.registerSingleton<ForgotPassword>(ForgotPassword(getIt()));

  // Blocs
  getIt.registerFactory(() => AuthBloc(
        signIn: getIt(),
        forgotPassword: getIt(),
      ));
  getIt.registerFactory(() => MedicineBloc(getIt<MedicineRepository>()));
}
