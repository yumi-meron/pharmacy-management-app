import 'package:dartz/dartz.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_detail.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../core/error/failure.dart';
import '../datasources/orders_remote_data_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remote;

  OrdersRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    final result = await remote.getOrders(); // Either<Failure, List<OrderModel>>
    return result.map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Either<Failure, OrderDetail>> getOrderDetail(String id) async {
    final result = await remote.getOrderDetail(id); // Either<Failure, OrderDetailModel>
    print('getOrderDetail result on Repository: $result');
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, Unit>> requestOrderOtp(String id, String phoneNumber) async {
    return await remote.requestOrderOtp(id, phoneNumber);
  }

  @override
  Future<Either<Failure, Unit>> verifyOrderOtp(String id, String otp) async {
    return await remote.verifyOrderOtp(id, otp);
  }
}
