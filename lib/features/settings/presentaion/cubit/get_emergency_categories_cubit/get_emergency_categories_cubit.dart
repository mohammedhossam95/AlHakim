import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/settings/domain/use_case/get_emergency_categories_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_emergency_categories_state.dart';

class GetEmergencyCategoriesCubit extends Cubit<GetEmergencyCategoriesState> {
  final GetEmergencyCategoriesUsecase usecase;

  GetEmergencyCategoriesCubit({required this.usecase})
      : super(GetEmergencyCategoriesInitial());

  Future<void> getEmergencyCategories() async {
    emit(GetEmergencyCategoriesLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(GetEmergencyCategoriesError(message: l.message ?? '')),
      (r) => emit(GetEmergencyCategoriesSuccess(response: r)),
    );
  }
}
