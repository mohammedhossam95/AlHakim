import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/domain/usecases/toggle_doctor_status_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'toggel_doctor_status_state.dart';

class ToggelDoctorStatusCubit extends Cubit<ToggelDoctorStatusState> {
  final ToggleDoctorStatusUsecase usecase;
  ToggelDoctorStatusCubit({required this.usecase})
    : super(ToggelDoctorStatusInitial());

  Future<void> toggleDoctorStatus(String id) async {
    emit(ToggleDoctorStatusLoading());

    final result = await usecase(id);

    result.fold(
      (l) => emit(ToggleDoctorStatusError(message: l.message ?? '')),
      (r) => emit(ToggleDoctorStatusSuccess(response: r)),
    );
  }
}
