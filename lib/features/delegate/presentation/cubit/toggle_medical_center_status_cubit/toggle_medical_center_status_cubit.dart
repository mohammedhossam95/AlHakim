import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/toggle_medical_center_status_params.dart';
import 'package:alhakim/features/delegate/domain/usecases/toggle_medical_center_status_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'toggle_medical_center_status_state.dart';

class ToggleMedicalCenterStatusCubit
    extends Cubit<ToggleMedicalCenterStatusState> {
  final ToggleMedicalCenterStatusUsecase usecase;

  ToggleMedicalCenterStatusCubit({required this.usecase})
      : super(ToggleMedicalCenterStatusInitial());

  Future<void> toggleMedicalCenterStatus(String id) async {
    emit(ToggleMedicalCenterStatusLoading());

    final result = await usecase(
      ToggleMedicalCenterStatusParams(medicalCenterId: id),
    );

    result.fold(
      (l) => emit(ToggleMedicalCenterStatusError(message: l.message ?? '')),
      (r) => emit(ToggleMedicalCenterStatusSuccess(response: r)),
    );
  }
}
