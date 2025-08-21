import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/usecases/orders/request_order_otp.dart';
import 'package:pharmacist_mobile/domain/usecases/orders/verify_order_otp.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/otp_verify/otp_verify_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/otp_verify/otp_verify_state.dart';

class OtpVerifyBloc extends Bloc<OtpVerifyEvent, OtpVerifyState> {
  final RequestOrderOtp requestOrderOtp;
  final VerifyOrderOtp verifyOrderOtp;

  OtpVerifyBloc({
    required this.requestOrderOtp,
    required this.verifyOrderOtp,
  }) : super(OtpVerifyInitial()) {
    on<RequestOrderOtpEvent>((event, emit) async {
      emit(OtpRequestLoading());
      final res = await requestOrderOtp(event.id, event.phoneNumber);
      res.fold(
        (failure) => emit(OtpVerifyError(_mapFailureToMessage(failure))),
        (_) => emit(OtpRequestSuccess()),
      );
    });
    on<OtpVerifyInitialEvent>((event, emit) {
      emit(OtpVerifyInitial());
    });

    on<VerifyOrderOtpEvent>((event, emit) async {
      emit(OtpVerifyLoading());
      final res = await verifyOrderOtp(event.id, event.otp);
      res.fold(
        (failure) => emit(OtpVerifyError(_mapFailureToMessage(failure))),
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
