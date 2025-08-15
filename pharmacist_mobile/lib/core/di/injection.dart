import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pharmacist_mobile/core/network/network_info.dart';

// Data Sources
import 'package:pharmacist_mobile/data/datasources/auth_remote_data_source.dart';
import 'package:pharmacist_mobile/data/datasources/employee_remote_datasource.dart';
import 'package:pharmacist_mobile/data/datasources/medicine_remote_data_source.dart';
import 'package:pharmacist_mobile/data/datasources/cart_remote_data_source.dart';
import 'package:pharmacist_mobile/data/datasources/orders_remote_data_source.dart';

// Repositories
import 'package:pharmacist_mobile/data/repositories/auth_repository_impl.dart';
import 'package:pharmacist_mobile/data/repositories/employee_repository_impl.dart';
import 'package:pharmacist_mobile/data/repositories/medicine_repository_impl.dart';
import 'package:pharmacist_mobile/data/repositories/cart_repository_impl.dart';
import 'package:pharmacist_mobile/data/repositories/orders_repository_impl.dart';

// Domain
import 'package:pharmacist_mobile/domain/repositories/auth_repository.dart';
import 'package:pharmacist_mobile/domain/repositories/employee_repository.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';
import 'package:pharmacist_mobile/domain/repositories/cart_repository.dart';
import 'package:pharmacist_mobile/domain/repositories/orders_repository.dart';
import 'package:pharmacist_mobile/domain/usecases/orders/get_orders.dart';
import 'package:pharmacist_mobile/domain/usecases/orders/get_order_detail.dart';
import 'package:pharmacist_mobile/domain/usecases/orders/request_order_otp.dart';
import 'package:pharmacist_mobile/domain/usecases/orders/verify_order_otp.dart';

// Auth Usecases
import 'package:pharmacist_mobile/domain/usecases/auth/sign_in.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/forgot_password.dart';
import 'package:pharmacist_mobile/domain/usecases/cart/check_out.dart';

// Medicine Usecases
import 'package:pharmacist_mobile/domain/usecases/medicine/get_medicine_details.dart';
import 'package:pharmacist_mobile/domain/usecases/medicine/search_medicine.dart';

// Cart Usecases
import 'package:pharmacist_mobile/domain/usecases/cart/get_cart_items.dart';
import 'package:pharmacist_mobile/domain/usecases/cart/remove_cart_item.dart';
import 'package:pharmacist_mobile/domain/usecases/cart/add_cart_item.dart';

// Blocs
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/employee/employee_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/cart/cart_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detail_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/orders_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/otp_verify/otp_verify_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setup() async {
  // External dependencies
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<http.Client>(http.Client());
  getIt.registerSingleton<InternetConnectionChecker>(
      InternetConnectionChecker.createInstance());

  // Core
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton(() => SearchMedicines(getIt()));

  // Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    RemoteDataSourceImpl(dio: getIt(), prefs: getIt()),
  );
  getIt.registerSingleton<MedicineRemoteDataSource>(
    MedicineRemoteDataSource(client: getIt(), prefs: getIt()),
  );
  getIt.registerSingleton<EmployeeDataSource>(
    EmployeeDataSourceImpl(prefs: getIt()),
  );
  getIt.registerSingleton<CartRemoteDataSource>(
    CartRemoteDataSourceImpl(dio: getIt(), prefs: getIt()),
  );
  getIt.registerSingleton<OrdersRemoteDataSource>(
    OrdersRemoteDataSourceImpl(prefs: getIt(), client: getIt()),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerSingleton<MedicineRepository>(
    MedicineRepositoryImpl(dataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerSingleton<EmployeeRepository>(
    EmployeeRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerSingleton<CartRepository>(
    CartRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerSingleton<OrdersRepository>(
    OrdersRepositoryImpl(remote: getIt()),
  );

  // Use Cases
  getIt.registerSingleton<SignIn>(SignIn(getIt()));
  getIt.registerSingleton<ForgotPassword>(ForgotPassword(getIt()));
  getIt.registerLazySingleton(() => GetMedicineDetails(getIt()));
  // orders use cases
  getIt.registerLazySingleton(() => GetOrders(getIt()));
  getIt.registerLazySingleton(() => GetOrderDetail(getIt()));
  getIt.registerLazySingleton(() => RequestOrderOtp(getIt()));
  getIt.registerLazySingleton(() => VerifyOrderOtp(getIt()));

  // Cart Use Cases
  getIt.registerLazySingleton(() => GetCartItems(getIt()));
  getIt.registerLazySingleton(() => RemoveCartItem(getIt()));
  getIt.registerLazySingleton(() => AddCartItem(getIt()));
  getIt.registerLazySingleton(() => CheckoutCart(getIt()));

  // Blocs
  getIt.registerFactory(() => AuthBloc(
        signIn: getIt(),
        forgotPassword: getIt(),
      ));
  getIt.registerFactory(() => MedicineBloc(
        getIt<MedicineRepository>(),
        repository: getIt<MedicineRepository>(),
        getMedicineDetails: getIt<GetMedicineDetails>(),
      ));
  getIt.registerFactory(() => EmployeeBloc(getIt<EmployeeRepository>()));
  getIt.registerFactory(() => CartBloc(
        getCartItems: getIt(),
        removeCartItem: getIt(),
        addCartItem: getIt(),
        checkoutCart: getIt(),
      ));
  getIt.registerFactory(() => OrdersBloc(
        getOrders: getIt(),
      ));
  getIt.registerFactory(() => OrderDetailBloc(
        getOrderDetail: getIt(),
      ));
  getIt.registerFactory(() => OtpVerifyBloc(
    requestOrderOtp: getIt(),
    verifyOrderOtp: getIt(),
  ));
}
