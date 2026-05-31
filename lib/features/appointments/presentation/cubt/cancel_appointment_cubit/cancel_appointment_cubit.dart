import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cancel_appointment_state.dart';

class CancelAppointmentCubit extends Cubit<CancelAppointmentState> {
  final CancelAppointmentUsecase usecase;

  CancelAppointmentCubit({required this.usecase})
    : super(CancelAppointmentInitial());

  Future<void> cancelAppointment({required String appointmentId}) async {
    emit(CancelAppointmentLoading());

    final result = await usecase(appointmentId);

    result.fold(
      (l) => emit(CancelAppointmentError(message: l.message ?? '')),
      (r) => emit(CancelAppointmentSuccess(response: r)),
    );
  }
}
