import 'package:equatable/equatable.dart';

class RepresentativeStatsEntity
    extends Equatable {
  final ClinicsStatsEntity? clinics;
  final AppointmentsStatsEntity?
      appointments;

  const RepresentativeStatsEntity({
    this.clinics,
    this.appointments,
  });

  @override
  List<Object?> get props => [
        clinics,
        appointments,
      ];
}

class ClinicsStatsEntity
    extends Equatable {
  final int? total;
  final int? active;
  final int? inactive;
  final int? open;
  final int? closed;
  final double? avgRating;

  const ClinicsStatsEntity({
    this.total,
    this.active,
    this.inactive,
    this.open,
    this.closed,
    this.avgRating,
  });

  @override
  List<Object?> get props => [
        total,
        active,
        inactive,
        open,
        closed,
        avgRating,
      ];
}

class AppointmentsStatsEntity
    extends Equatable {
  final int? total;
  final int? pending;
  final int? confirmed;
  final int? cancelled;
  final int? completed;

  const AppointmentsStatsEntity({
    this.total,
    this.pending,
    this.confirmed,
    this.cancelled,
    this.completed,
  });

  @override
  List<Object?> get props => [
        total,
        pending,
        confirmed,
        cancelled,
        completed,
      ];
}