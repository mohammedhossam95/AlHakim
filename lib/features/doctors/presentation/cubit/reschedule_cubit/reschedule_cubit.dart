import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/reschedule_params.dart';
import 'package:alhakim/features/doctors/domain/usecases/reschedule_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reschedule_state.dart';

class RescheduleCubit extends Cubit<RescheduleState> {
  final RescheduleUsecase usecase;

  RescheduleCubit({required this.usecase}) : super(RescheduleInitial());

  Future<void> reschedule({required RescheduleParams params}) async {
    emit(RescheduleLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(RescheduleError(message: l.message ?? '')),
      (r) => emit(RescheduleSuccess(response: r)),
    );
  }
}
