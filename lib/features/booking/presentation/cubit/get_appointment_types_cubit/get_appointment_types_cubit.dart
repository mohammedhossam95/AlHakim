import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/booking/domain/usecases/get_appointment_types_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_appointment_types_state.dart';

class GetAppointmentTypesCubit extends Cubit<GetAppointmentTypesState> {
  final GetAppointmentTypesUsecase usecase;

  GetAppointmentTypesCubit({required this.usecase})
    : super(GetAppointmentTypesInitial());

  Future<void> getAppointmentTypes() async {
    emit(GetAppointmentTypesLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(GetAppointmentTypesError(message: l.message ?? '')),
      (r) => emit(GetAppointmentTypesSuccess(response: r)),
    );
  }
}
