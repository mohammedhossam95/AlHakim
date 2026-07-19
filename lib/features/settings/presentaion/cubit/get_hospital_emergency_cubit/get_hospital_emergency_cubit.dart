import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/settings/domain/use_case/get_hospital_emergency_usecase.dart';
import 'package:alhakim/features/settings/domain/use_case/params/get_hospital_emergency_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_hospital_emergency_state.dart';

class GetHospitalEmergencyCubit extends Cubit<GetHospitalEmergencyState> {
  final GetHospitalEmergencyUsecase usecase;

  GetHospitalEmergencyCubit({required this.usecase})
      : super(GetHospitalEmergencyInitial());

  Future<void> getHospitalEmergencyNumbers({
    int? perPage,
    String? search,
  }) async {
    emit(GetHospitalEmergencyLoading());

    final result = await usecase(
      GetHospitalEmergencyParams(perPage: perPage, search: search),
    );

    result.fold(
      (l) => emit(GetHospitalEmergencyError(message: l.message ?? '')),
      (r) => emit(GetHospitalEmergencySuccess(response: r)),
    );
  }
}
