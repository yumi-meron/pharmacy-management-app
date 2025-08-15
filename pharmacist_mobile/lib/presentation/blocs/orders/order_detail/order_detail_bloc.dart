import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/usecases/orders/get_order_detail.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detail_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detain_event.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final GetOrderDetail getOrderDetail;

  OrderDetailBloc({required this.getOrderDetail}) : super(OrderDetailInitial()) {
    on<LoadOrderDetailEvent>((event, emit) async {
      emit(OrderDetailLoading());
      final res = await getOrderDetail(event.id);
      res.fold(
        (failure) => emit(OrderDetailError(_mapFailureToMessage(failure))),
        (detail) => emit(OrderDetailLoaded(detail)),
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