import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/domain/entities/order.dart';

import '../../core/error/failure.dart';
import '../entities/order_detail.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderDetail>> getOrderDetail(String id);
  Future<Either<Failure, Unit>> requestOrderOtp(String id, String phoneNumber);
  Future<Either<Failure, Unit>> verifyOrderOtp(String id, String otp);
}
