import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/domain/usecases/login_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login(AuthParams params) async {
    emit(LoginIsLoading());
    try {
      final Either<Failure, BaseOneResponse> eitherResult = await loginUseCase(
        params,
      );
      eitherResult.fold(
        (Failure failure) {
          emit(LoginError(params: params, message: failure.message ?? ''));
        },
        (BaseOneResponse response) {
          emit(LoginLoaded(params: params, response: response));
        },
      );
    } catch (e) {
      emit(LoginError(params: params, message: e.toString()));
    }
  }
}
