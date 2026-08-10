import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/auth/domain/usecases/params/reset_password_params.dart';
import 'package:alhakim/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase usecase;

  ResetPasswordCubit({required this.usecase}) : super(ResetPasswordInitial());

  Future<void> resetPassword(ResetPasswordParams params) async {
    emit(ResetPasswordLoading());

    final result = await usecase(params);

    result.fold(
      (failure) => emit(ResetPasswordError(message: failure.message ?? '')),
      (response) => emit(ResetPasswordSuccess(response: response)),
    );
  }
}
