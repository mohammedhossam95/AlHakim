import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/notifications/domain/usecases/get_notifications_count_usecase.dart';

part 'notifications_count_state.dart';

class NotificationsCountCubit extends Cubit<NotificationsCountState> {
  final NotificationsCountUseCase notificationsCountUseCase;
  bool isLoading = true;
  NotificationsCountCubit(this.notificationsCountUseCase)
      : super(NotificationsCountInitial());
  Future<void> fGetCount() async {
    changeLoadingView();
    try {
      Either<Failure, BaseOneResponse> response =
          await notificationsCountUseCase(NoParams());
      changeLoadingView();
      emit(response.fold(
        (failure) =>
            NotificationsCountFailureState(errorMessage: failure.message ?? ''),
        (list) => NotificationsCountSuccessState(response: list),
      ));
    } catch (e) {
      
      emit(NotificationsCountFailureState(errorMessage: e.toString()));
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(NotificationsCountLoadingState(isLoading: isLoading));
  }
}
