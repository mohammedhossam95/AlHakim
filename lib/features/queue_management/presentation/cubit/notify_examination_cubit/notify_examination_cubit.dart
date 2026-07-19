import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/queue_management/domain/usecases/notify_examination_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notify_examination_state.dart';

class NotifyExaminationCubit extends Cubit<NotifyExaminationState> {
  final NotifyExaminationUsecase usecase;

  NotifyExaminationCubit({required this.usecase})
    : super(NotifyExaminationInitial());

  Future<void> notifyExamination({required String appointmentId}) async {
    emit(NotifyExaminationLoading(appointmentId: appointmentId));

    final result = await usecase(appointmentId: appointmentId);

    result.fold(
      (l) => emit(NotifyExaminationError(message: l.message ?? '')),
      (r) => emit(NotifyExaminationSuccess(response: r)),
    );
  }
}
