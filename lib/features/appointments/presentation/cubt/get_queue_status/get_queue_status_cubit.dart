import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/appointments/domain/usecases/get_queue_status_usecase.dart';
import 'package:alhakim/features/appointments/domain/usecases/params/get_queue_status_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_queue_status_state.dart';

class GetQueueStatusCubit extends Cubit<GetQueueStatusState> {
  final GetQueueStatusUsecase usecase;

  GetQueueStatusCubit({required this.usecase}) : super(GetQueueStatusInitial());

  Future<void> getQueueStatus({required String appointmentId}) async {
    emit(GetQueueStatusLoading());

    final result = await usecase(
      GetQueueStatusParams(appointmentId: appointmentId),
    );

    result.fold(
      (l) => emit(GetQueueStatusError(message: l.message ?? '')),
      (r) => emit(GetQueueStatusSuccess(response: r)),
    );
  }
}
