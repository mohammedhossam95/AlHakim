import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/params/forgot_password_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase usecase;

  ForgotPasswordCubit({required this.usecase}) : super(ForgotPasswordInitial());

  Future<void> forgotPassword(ForgotPasswordParams params) async {
    emit(ForgotPasswordLoading());

    final result = await usecase(params);

    result.fold(
      (failure) => emit(ForgotPasswordError(message: failure.message ?? '')),
      (response) {
        final data = response.data;
        final nextStep = data is AuthModel ? data.nextStep : null;

        emit(
          ForgotPasswordSuccess(
            response: response,
            resetParams: AuthParams(
              phoneNumber: params.phoneNumber,
              countryCode: params.countryCode,
            ),
            nextStep: nextStep,
          ),
        );
      },
    );
  }
}
