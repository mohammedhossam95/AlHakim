import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/specialities/domain/usecases/get_specialty_doctors_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_specialty_doctors_state.dart';

class GetSpecialtyDoctorsCubit extends Cubit<GetSpecialtyDoctorsState> {
  final GetSpecialtyDoctorsUsecase usecase;

  GetSpecialtyDoctorsCubit({required this.usecase})
    : super(GetSpecialtyDoctorsInitial());

  Future<void> getSpecialtyDoctors(String id) async {
    emit(GetSpecialtyDoctorsLoading());

    final result = await usecase(id);

    result.fold(
      (l) => emit(GetSpecialtyDoctorsError(message: l.message ?? '')),
      (r) => emit(GetSpecialtyDoctorsSuccess(response: r)),
    );
  }
}
