import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/entities/order.dart';
import '../../../domain/usecases/orders/get_orders.dart';
import '../../../domain/usecases/orders/get_order_detail.dart';
import '../../../domain/usecases/orders/request_order_otp.dart';
import '../../../domain/usecases/orders/verify_order_otp.dart';
import '../../../core/error/failure.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrders getOrders;
  final GetOrderDetail getOrderDetail;
  final RequestOrderOtp requestOrderOtp;
  final VerifyOrderOtp verifyOrderOtp;

  OrdersBloc({
    required this.getOrders,
    required this.getOrderDetail,
    required this.requestOrderOtp,
    required this.verifyOrderOtp,
  }) : super(OrdersInitial()) {

    on<LoadOrdersEvent>((event, emit) async {
      emit(OrdersLoading());
      final res = await getOrders();
      res.fold(
        (failure) => emit(OrdersError(_mapFailureToMessage(failure))),
        (orders) => emit(OrdersLoaded(orders)),
      );
    });

    on<LoadOrderDetailEvent>((event, emit) async {
      emit(OrderDetailLoading());
      final res = await getOrderDetail(event.id);
      print('LoadOrderDetailEvent result: $res');
      res.fold(
        (failure) => emit(OrdersError(_mapFailureToMessage(failure))),
        (detail) => emit(OrderDetailLoaded(detail)),
      );
    });

    on<RequestOrderOtpEvent>((event, emit) async {
      emit(OrdersLoading());
      final res = await requestOrderOtp(event.id, event.phoneNumber);
      res.fold(
        (failure) => emit(OrdersError(_mapFailureToMessage(failure))),
        (_) => emit(OtpRequestSuccess()),
      );
    });

    on<VerifyOrderOtpEvent>((event, emit) async {
      emit(OrdersLoading());
      final res = await verifyOrderOtp(event.id, event.otp);
      res.fold(
        (failure) => emit(OrdersError(_mapFailureToMessage(failure))),
        (_) => emit(OtpVerifySuccess()),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return failure.message;
    } else if (failure is ServerFailure) {
      return failure.message;
    } else {
      return 'Unexpected error';
    }
  }
}
