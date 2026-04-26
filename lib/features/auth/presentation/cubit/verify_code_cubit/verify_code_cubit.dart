import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/domain/usecases/verify_code_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';

part 'verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  final VerifyCodeUseCase verifyCodeUseCase;

  VerifyCodeCubit({required this.verifyCodeUseCase})
    : super(VerifyCodeInitial());

  Future<void> verifyCode(AuthParams params) async {
    emit(VerifyCodeIsLoading());
    try {
      final Either<Failure, BaseOneResponse> eitherResult =
          await verifyCodeUseCase(params);
      eitherResult.fold(
        (Failure failure) {
          emit(VerifyCodeError(failure.message ?? ''));
        },
        (BaseOneResponse response) {
          emit(VerifyCodeLoaded(response: response));
        },
      );
    } catch (e) {
      emit(VerifyCodeError(e.toString()));
    }
  }
}
