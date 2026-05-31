import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/params/appoinments_params.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_doctor_appoinments_for_day_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_doctor_appoinments_for_day_state.dart';

class GetDoctorAppoinmentsForDayCubit
    extends Cubit<GetDoctorAppoinmentsForDayState> {
  final GetDoctorAppoinmentsForDayUsecase usecase;

  GetDoctorAppoinmentsForDayCubit({required this.usecase})
    : super(GetDoctorAppoinmentsForDayInitial());

  Future<void> getDoctorAppoinmentsForDay({
    required AppoinmentsParams params,
  }) async {
    emit(GetDoctorAppoinmentsForDayLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(GetDoctorAppoinmentsForDayError(message: l.message ?? '')),
      (r) => emit(GetDoctorAppoinmentsForDaySuccess(response: r)),
    );
  }
}
