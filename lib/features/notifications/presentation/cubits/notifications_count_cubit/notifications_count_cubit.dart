import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/notifications/domain/usecases/get_notifications_count_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'notifications_count_state.dart';

class NotificationsCountCubit extends Cubit<NotificationsCountState> {
  final NotificationsCountUseCase notificationsCountUseCase;

  NotificationsCountCubit(this.notificationsCountUseCase)
    : super(const NotificationsCountInitial());

  Future<void> fGetCount() async {
    emit(const NotificationsCountLoadingState());

    final Either<Failure, int> response = await notificationsCountUseCase(
      NoParams(),
    );

    emit(
      response.fold(
        (Failure failure) =>
            NotificationsCountFailureState(errorMessage: failure.message ?? ''),
        (int unreadCount) =>
            NotificationsCountSuccessState(unreadCount: unreadCount),
      ),
    );
  }
}
