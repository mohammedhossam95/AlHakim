import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/add_doctor_params.dart';
import 'package:alhakim/features/doctors/domain/usecases/update_doctor_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_doctor_state.dart';

class UpdateDoctorCubit extends Cubit<UpdateDoctorState> {
  final UpdateDoctorUsecase usecase;

  UpdateDoctorCubit({required this.usecase}) : super(UpdateDoctorInitial());

  Future<void> updateDoctor({required AddDoctorParams params}) async {
    emit(UpdateDoctorLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(UpdateDoctorError(message: l.message ?? '')),

      (r) => emit(UpdateDoctorSuccess(response: r)),
    );
  }
}
