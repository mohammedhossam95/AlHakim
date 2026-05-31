import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_doctor_home_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_doctor_home_state.dart';

class GetDoctorHomeCubit extends Cubit<GetDoctorHomeState> {
  final GetDoctorHomeUsecase usecase;

  GetDoctorHomeCubit({required this.usecase}) : super(GetDoctorHomeInitial());

  Future<void> getDoctorHome() async {
    emit(GetDoctorHomeLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(GetDoctorHomeError(message: l.message ?? '')),
      (r) => emit(GetDoctorHomeSuccess(response: r)),
    );
  }
}
