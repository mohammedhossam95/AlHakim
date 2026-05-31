import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/queue_management/domain/usecases/get_queue_management_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_queue_management_state.dart';

class GetQueueManagementCubit extends Cubit<GetQueueManagementState> {
  final GetQueueManagementUsecase usecase;

  GetQueueManagementCubit({required this.usecase})
    : super(GetQueueManagementInitial());

  Future<void> getQueueManagement({required String doctorId}) async {
    emit(GetQueueManagementLoading());

    final result = await usecase(doctorId: doctorId);

    result.fold(
      (l) => emit(GetQueueManagementError(message: l.message ?? '')),
      (r) => emit(GetQueueManagementSuccess(response: r)),
    );
  }
}
