import 'package:equatable/equatable.dart';

class QueueStatusEntity extends Equatable {
  final int? appointmentId;
  final String? status;
  final bool? isCurrent;
  final bool? clinicStarted;
  final bool? isMissedTurn;
  final String? yourQueueNumber;
  final String? currentQueueNumber;
  final int? patientsAhead;
  final int? slotDuration;
  final int? estimatedWaitMinutes;

  const QueueStatusEntity({
    this.appointmentId,
    this.status,
    this.isCurrent,
    this.clinicStarted,
    this.isMissedTurn,
    this.yourQueueNumber,
    this.currentQueueNumber,
    this.patientsAhead,
    this.slotDuration,
    this.estimatedWaitMinutes,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        status,
        isCurrent,
        clinicStarted,
        isMissedTurn,
        yourQueueNumber,
        currentQueueNumber,
        patientsAhead,
        slotDuration,
        estimatedWaitMinutes,
      ];
}
