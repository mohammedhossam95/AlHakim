import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/queue_management/domain/usecases/broadcast_message_usecase.dart';
import 'package:alhakim/features/queue_management/domain/usecases/update_queue_message_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'patient_message_state.dart';

enum PatientMessageType {
  /// Sent once as a push notification to the doctor's patients.
  broadcast,

  /// Shown on the patients' queue tracking page until it's changed.
  queue,
}

class PatientMessageCubit extends Cubit<PatientMessageState> {
  final BroadcastMessageUsecase broadcastMessageUsecase;
  final UpdateQueueMessageUsecase updateQueueMessageUsecase;

  PatientMessageCubit({
    required this.broadcastMessageUsecase,
    required this.updateQueueMessageUsecase,
  }) : super(PatientMessageInitial());

  Future<void> send({
    required PatientMessageType type,
    required String doctorId,
    required String message,
  }) async {
    emit(PatientMessageLoading());

    final Either<Failure, BaseOneResponse> result = switch (type) {
      PatientMessageType.broadcast => await broadcastMessageUsecase(
        doctorId: doctorId,
        message: message,
      ),
      PatientMessageType.queue => await updateQueueMessageUsecase(
        doctorId: doctorId,
        message: message,
      ),
    };

    result.fold(
      (l) => emit(PatientMessageError(message: l.message ?? '')),
      (r) => emit(PatientMessageSuccess(response: r)),
    );
  }
}
