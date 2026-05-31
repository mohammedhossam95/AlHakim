import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/delegate/domain/usecases/get_representative_stats_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_representative_stats_state.dart';

class GetRepresentativeStatsCubit extends Cubit<GetRepresentativeStatsState> {
  final GetRepresentativeStatsUsecase usecase;

  GetRepresentativeStatsCubit({required this.usecase})
    : super(GetRepresentativeStatsInitial());

  Future<void> getRepresentativeStats() async {
    emit(GetRepresentativeStatsLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(GetRepresentativeStatsError(message: l.message ?? '')),
      (r) => emit(GetRepresentativeStatsSuccess(response: r)),
    );
  }
}
