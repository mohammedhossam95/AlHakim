import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/queue_management/domain/usecases/update_queue_status_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_queue_status_state.dart';

class UpdateQueueStatusCubit extends Cubit<UpdateQueueStatusState> {
  final UpdateQueueStatusUsecase usecase;

  UpdateQueueStatusCubit({required this.usecase})
    : super(UpdateQueueStatusInitial());

  Future<void> updateQueueStatus({
    required String doctorId,
    required int appointmentId,
    required String status,
  }) async {
    emit(UpdateQueueStatusLoading(appointmentId: appointmentId));

    final result = await usecase(
      doctorId: doctorId,
      appointmentId: appointmentId,
      status: status,
    );

    result.fold(
      (l) => emit(UpdateQueueStatusError(message: l.message ?? '')),
      (r) => emit(UpdateQueueStatusSuccess(response: r)),
    );
  }
}
