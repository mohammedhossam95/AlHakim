import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/logout_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUsecase;

  LogoutCubit({required this.logoutUsecase}) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    final result = await logoutUsecase(NoParams());

    result.fold(
      (l) => emit(LogoutError(message: l.message ?? '')),
      (r) => emit(LogoutSuccess()),
    );
  }
}
