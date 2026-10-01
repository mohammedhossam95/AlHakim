import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/queue_management/domain/usecases/broadcast_message_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'broadcast_message_state.dart';

class BroadcastMessageCubit extends Cubit<BroadcastMessageState> {
  final BroadcastMessageUsecase usecase;

  BroadcastMessageCubit({required this.usecase})
    : super(BroadcastMessageInitial());

  Future<void> broadcastMessage({
    required String doctorId,
    required String message,
  }) async {
    emit(BroadcastMessageLoading());

    final result = await usecase(doctorId: doctorId, message: message);

    result.fold(
      (l) => emit(BroadcastMessageError(message: l.message ?? '')),
      (r) => emit(BroadcastMessageSuccess(response: r)),
    );
  }
}
