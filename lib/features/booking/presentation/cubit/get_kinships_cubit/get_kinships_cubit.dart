import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/booking/domain/usecases/get_kinships_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_kinships_state.dart';

class GetKinshipsCubit extends Cubit<GetKinshipsState> {
  final GetKinshipsUsecase usecase;

  GetKinshipsCubit({required this.usecase}) : super(GetKinshipsInitial());

  Future<void> getKinships() async {
    emit(GetKinshipsLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(GetKinshipsError(message: l.message ?? '')),
      (r) => emit(GetKinshipsSuccess(response: r)),
    );
  }
}
