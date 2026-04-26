// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/delete_user_account_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'delete_user_account_state.dart';

class DeleteUserAccountCubit extends Cubit<DeleteUserAccountState> {
  final DeleteUserAccountUsecase useCase;
  DeleteUserAccountCubit(this.useCase) : super(DeleteUserAccountInitial());
  Future<void> deleteUserAccount() async {
    emit(DeleteUserAccountLoading(isLoading: true));
    try {
      final Either<Failure, BaseOneResponse> eitherResult = await useCase.call(
        NoParams(),
      );
      emit(DeleteUserAccountLoading(isLoading: false));
      eitherResult.fold(
        (Failure failure) {
          emit(DeleteUserAccountError(failure.message ?? ''));
        },
        (BaseOneResponse response) {
          emit(DeleteUserAccountLoaded(response: response));
        },
      );
    } catch (e) {
      emit(DeleteUserAccountError(e.toString()));
    }
  }
}
