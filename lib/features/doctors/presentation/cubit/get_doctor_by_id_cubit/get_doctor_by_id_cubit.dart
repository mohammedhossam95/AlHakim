import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_doctor_by_id_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_doctor_by_id_state.dart';

class GetDoctorByIdCubit extends Cubit<GetDoctorByIdState> {
  final GetDoctorByIdUsecase usecase;

  GetDoctorByIdCubit({required this.usecase}) : super(GetDoctorByIdInitial());

  Future<void> getDoctorById(String doctorId) async {
    final trimmedId = doctorId.trim();
    if (trimmedId.isEmpty) {
      emit(const GetDoctorByIdError(message: 'Doctor id is required.'));
      return;
    }

    emit(GetDoctorByIdLoading());

    final result = await usecase(trimmedId);

    result.fold(
      (l) => emit(GetDoctorByIdError(message: l.message ?? '')),
      (r) => emit(GetDoctorByIdSuccess(doctor: r)),
    );
  }
}
