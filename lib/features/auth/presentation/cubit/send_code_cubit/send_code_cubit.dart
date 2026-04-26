import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/domain/usecases/send_code_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';

part 'send_code_state.dart';

class SendCodeCubit extends Cubit<SendCodeState> {
  final SendCodeUseCase sendCodeUseCase;

  SendCodeCubit({required this.sendCodeUseCase}) : super(SendCodeInitial());

  Future<void> sendCode(AuthParams params) async {
    emit(SendCodeIsLoading());
    try {
      final Either<Failure, BaseOneResponse> eitherResult =
          await sendCodeUseCase(params);
      eitherResult.fold(
        (Failure failure) {
          emit(SendCodeError(failure.message ?? ''));
        },
        (BaseOneResponse response) {
          emit(SendCodeLoaded(response: response));
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
