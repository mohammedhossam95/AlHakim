import 'package:equatable/equatable.dart';

class QueueStatusEntity extends Equatable {
  final int? appointmentId;
  final String? status;
  final bool? isCurrent;
  final bool? clinicStarted;
  final bool? clinicOpen;
  final bool? isMissedTurn;
  final String? yourQueueNumber;
  final String? currentQueueNumber;
  final int? patientsAhead;
  final int? slotDuration;
  final int? estimatedWaitMinutes;
  final List<Ad>? ads;

  const QueueStatusEntity({
    this.appointmentId,
    this.status,
    this.isCurrent,
    this.clinicStarted,
    this.clinicOpen,
    this.isMissedTurn,
    this.yourQueueNumber,
    this.currentQueueNumber,
    this.patientsAhead,
    this.slotDuration,
    this.estimatedWaitMinutes,
    this.ads,
  });

  @override
  List<Object?> get props => [
    appointmentId,
    status,
    isCurrent,
    clinicStarted,
    clinicOpen,
    isMissedTurn,
    yourQueueNumber,
    currentQueueNumber,
    patientsAhead,
    slotDuration,
    estimatedWaitMinutes,
    ads,
  ];
}

class Ad extends Equatable {
  final int? id;
  final String? photo;
  final String? link;

  const Ad({this.id, this.photo, this.link});

  @override
  List<Object?> get props => [id, photo, link];
}
