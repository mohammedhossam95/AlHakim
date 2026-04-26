import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/domain/usecases/register_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial());

  Future<void> register(AuthParams params) async {
    emit(RegisterIsLoading(isLoading: true));
    try {
      final Either<Failure, BaseOneResponse> eitherResult =
          await registerUseCase(params);
      emit(RegisterIsLoading(isLoading: false));
      eitherResult.fold(
        (Failure failure) {
          emit(RegisterError(failure.message ?? ''));
        },
        (BaseOneResponse response) {
          emit(RegisterLoaded(params: params, response: response));
        },
      );
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
