import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/domain/usecases/delete_schedule_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/params/delete_schedule_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_schedule_state.dart';

class DeleteScheduleCubit extends Cubit<DeleteScheduleState> {
  final DeleteScheduleUsecase usecase;

  DeleteScheduleCubit({required this.usecase}) : super(DeleteScheduleInitial());

  Future<void> deleteSchedule({required DeleteScheduleParams params}) async {
    emit(DeleteScheduleLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(DeleteScheduleError(message: l.message ?? '')),
      (r) => emit(DeleteScheduleSuccess(response: r)),
    );
  }
}
