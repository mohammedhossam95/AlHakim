import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/domain/usecases/params/update_schedule_status_params.dart';
import 'package:alhakim/features/doctors/domain/usecases/update_schedule_status_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_schedule_status_state.dart';

class UpdateScheduleStatusCubit extends Cubit<UpdateScheduleStatusState> {
  final UpdateScheduleStatusUsecase usecase;

  UpdateScheduleStatusCubit({required this.usecase})
    : super(UpdateScheduleStatusInitial());

  Future<void> updateScheduleStatus({
    required UpdateScheduleStatusParams params,
  }) async {
    emit(UpdateScheduleStatusLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(UpdateScheduleStatusError(message: l.message ?? '')),
      (r) => emit(UpdateScheduleStatusSuccess(response: r)),
    );
  }
}
