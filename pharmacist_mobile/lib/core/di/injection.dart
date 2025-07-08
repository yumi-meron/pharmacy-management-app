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
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setup() async {
  // External dependencies
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<http.Client>(http.Client());
  getIt.registerSingleton<InternetConnectionChecker>(InternetConnectionChecker.createInstance());

  // Core
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(getIt()));

  // Data Sources
  // getIt.registerSingleton<AuthRemoteDataSource>(RemoteDataSourceImpl(dio: getIt()));

  //Fake path
  getIt.registerSingleton<AuthRemoteDataSource>(MockAuthRemoteDataSource());


  getIt.registerSingleton<MedicineRemoteDataSource>(MedicineRemoteDataSource(client: getIt()));

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );


  //real path
  // getIt.registerSingleton<MedicineRepository>(
  //   MedicineRepositoryImpl(dataSource: getIt(), networkInfo: getIt()),
  // );
  //fake
  getIt.registerSingleton<MedicineRepository>(MockMedicineRepository());


  
  // Use Cases
  getIt.registerSingleton<SignIn>(SignIn(getIt()));
  getIt.registerSingleton<ForgotPassword>(ForgotPassword(getIt()));

  // Blocs
  getIt.registerFactory(() => AuthBloc(
        signIn: getIt(),
        forgotPassword: getIt(),
      ));
}
