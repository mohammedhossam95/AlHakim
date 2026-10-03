import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/queue_management/domain/usecases/get_queue_management_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_queue_management_state.dart';

class GetQueueManagementCubit extends Cubit<GetQueueManagementState> {
  final GetQueueManagementUsecase usecase;

  GetQueueManagementCubit({required this.usecase})
    : super(GetQueueManagementInitial());

  bool _hasLoaded = false;

  Future<void> loadIfNeeded({required String doctorId}) async {
    if (_hasLoaded) return;

    _hasLoaded = true;
    await getQueueManagement(doctorId: doctorId);
  }

  /// With [silent], the list already on screen stays there while loading,
  /// and a failure keeps it instead of replacing it with an error. It only
  /// applies when there's data to keep; otherwise it loads normally.
  Future<void> getQueueManagement({
    required String doctorId,
    bool silent = false,
  }) async {
    final keepCurrent = silent && state is GetQueueManagementSuccess;
    if (!keepCurrent) emit(GetQueueManagementLoading());

    final result = await usecase(doctorId: doctorId);
    if (isClosed) return;

    result.fold((l) {
      if (keepCurrent) return;
      emit(GetQueueManagementError(message: l.message ?? ''));
    }, (r) => emit(GetQueueManagementSuccess(response: r)));
  }
}
