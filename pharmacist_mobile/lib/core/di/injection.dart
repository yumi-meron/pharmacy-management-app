import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pharmacist_mobile/data/datasources/auth_remote_data_source.dart';
import 'package:pharmacist_mobile/data/datasources/medicine_remote_data_source.dart';
import 'package:pharmacist_mobile/data/repositories/auth_repository_impl.dart';
import 'package:pharmacist_mobile/domain/repositories/auth_repository.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/sign_in.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/forgot_password.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // External
  locator.registerLazySingleton(() => Dio());

  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
      () => RemoteDataSourceImpl(dio: locator()));

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: locator()));

  // Use cases
  locator.registerLazySingleton(() => SignIn(locator()));
  locator.registerLazySingleton(() => ForgotPassword(locator()));

  // Blocs
  locator.registerFactory(() => AuthBloc(
        signIn: locator(),
        forgotPassword: locator(),
      ));
  
  locator.registerLazySingleton<MedicineRemoteDataSource>(
        () => MedicineRemoteDataSource(client: MockClient((request) async => http.Response('{}', 200))),
      );
  // locator.registerLazySingleton<MedicineRemoteDataSource>(
  //       () => MedicineRemoteDataSource(),
  //     );
}