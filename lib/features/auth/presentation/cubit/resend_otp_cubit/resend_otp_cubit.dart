import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'resend_otp_state.dart';

class ResendOtpCubit extends Cubit<ResendOtpState> {
  final ResendOtpUsecase usecase;

  ResendOtpCubit({required this.usecase})
      : super(ResendOtpInitial());

  Future<void> resendOtp(AuthParams params) async {
    emit(ResendOtpLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(ResendOtpError(message: l.message ?? '')),
      (r) => emit(ResendOtpSuccess(response: r)),
    );
  }
}