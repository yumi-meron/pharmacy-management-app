import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/orders/get_orders.dart';
import '../../../core/error/failure.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrders getOrders;

  OrdersBloc({
    required this.getOrders,
  }) : super(OrdersInitial()) {
    on<LoadOrdersEvent>((event, emit) async {
      emit(OrdersLoading());
      final res = await getOrders();
      res.fold(
        (failure) => emit(OrdersError(_mapFailureToMessage(failure))),
        (orders) => emit(OrdersLoaded(orders)),
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
