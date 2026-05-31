import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/specialities/domain/usecases/get_specialties_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_specialties_state.dart';

class GetSpecialtiesCubit
    extends Cubit<GetSpecialtiesState> {
  final GetSpecialtiesUsecase usecase;

  GetSpecialtiesCubit({
    required this.usecase,
  }) : super(GetSpecialtiesInitial());

  Future<void> getSpecialties() async {
    emit(GetSpecialtiesLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(
        GetSpecialtiesError(
          message: l.message ?? '',
        ),
      ),
      (r) => emit(
        GetSpecialtiesSuccess(response: r),
      ),
    );
  }
}