import 'package:dartz/dartz.dart';
import '../../repositories/orders_repository.dart';
import '../../../core/error/failure.dart';
import '../../entities/order.dart';

class GetOrders {
  final OrdersRepository repository;
  GetOrders(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() {
    return repository.getOrders();
  }
}
