import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/params/appoinments_params.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_doctor_appoinments_for_day_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_affected_appoinments_state.dart';

class GetAffectedAppoinmentsCubit extends Cubit<GetAffectedAppoinmentsState> {
  final GetAffectedAppoinmentsUsecase usecase;

  GetAffectedAppoinmentsCubit({required this.usecase})
    : super(GetAffectedAppoinmentsInitial());

  Future<void> getAffectedAppoinments({
    required AppoinmentsParams params,
  }) async {
    emit(GetAffectedAppoinmentsLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(GetAffectedAppoinmentsError(message: l.message ?? '')),
      (r) => emit(GetAffectedAppoinmentsSuccess(response: r)),
    );
  }
}
