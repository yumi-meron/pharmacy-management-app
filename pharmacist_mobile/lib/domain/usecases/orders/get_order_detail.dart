import 'package:dartz/dartz.dart';
import '../../repositories/orders_repository.dart';
import '../../../core/error/failure.dart';
import '../../entities/order_detail.dart';

class GetOrderDetail {
  final OrdersRepository repository;
  GetOrderDetail(this.repository);

  Future<Either<Failure, OrderDetail>> call(String id) {
    return repository.getOrderDetail(id);
  }
}
