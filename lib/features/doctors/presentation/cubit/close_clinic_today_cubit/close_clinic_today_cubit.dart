import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/domain/usecases/close_clinic_today_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'close_clinic_today_state.dart';

class CloseClinicTodayCubit extends Cubit<CloseClinicTodayState> {
  final CloseClinicTodayUsecase usecase;

  CloseClinicTodayCubit({required this.usecase})
    : super(CloseClinicTodayInitial());

  Future<void> closeClinicToday({required String doctorId}) async {
    emit(CloseClinicTodayLoading());

    final result = await usecase(doctorId);

    result.fold(
      (l) => emit(CloseClinicTodayError(message: l.message ?? '')),
      (r) => emit(CloseClinicTodaySuccess(response: r)),
    );
  }
}
