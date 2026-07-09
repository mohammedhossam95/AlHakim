import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_appointments_state.dart';

class GetAppointmentsCubit extends Cubit<GetAppointmentsState> {
  final GetAppointmentsUsecase usecase;

  GetAppointmentsCubit({required this.usecase})
    : super(GetAppointmentsInitial());

  bool _hasLoaded = false;

  Future<void> loadIfNeeded() async {
    if (_hasLoaded) return;

    _hasLoaded = true;
    await getAppointments();
  }

  Future<void> getAppointments() async {
    emit(GetAppointmentsLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(GetAppointmentsError(message: l.message ?? '')),
      (r) => emit(GetAppointmentsSuccess(response: r)),
    );
  }
}
