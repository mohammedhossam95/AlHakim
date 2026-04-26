import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/notifications/domain/usecases/get_notifications_usecase.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase notificationsUseCase;
  bool isLoading = true;
  NotificationsCubit(this.notificationsUseCase) : super(NotificationsInitial());
  Future<void> fGetNotifications() async {
    changeLoadingView();
    try {
      Either<Failure, BaseOneResponse> response = await notificationsUseCase(
        NoParams(),
      );
      changeLoadingView();
      emit(
        response.fold(
          (failure) =>
              NotificationsFailureState(errorMessage: failure.message ?? ''),
          (list) => NotificationsSuccessState(response: list),
        ),
      );
    } catch (e) {
      emit(NotificationsFailureState(errorMessage: e.toString()));
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(NotificationsLoadingState(isLoading: isLoading));
  }
}
