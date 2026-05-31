import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/delegate/domain/entities/representative_stats_entity.dart';

class RepresentativeStatsRespModel
    extends BaseOneResponse {
  const RepresentativeStatsRespModel({
    super.status,
    super.message,
    super.data,
  });

  factory RepresentativeStatsRespModel
      .fromJson(
    Map<String, dynamic> json,
  ) {
    return RepresentativeStatsRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? RepresentativeStatsModel
              .fromJson(
              json['data'],
            )
          : null,
    );
  }
}

class RepresentativeStatsModel
    extends RepresentativeStatsEntity {
  const RepresentativeStatsModel({
    super.clinics,
    super.appointments,
  });

  factory RepresentativeStatsModel
      .fromJson(
    Map<String, dynamic> json,
  ) {
    return RepresentativeStatsModel(
      clinics: json['clinics'] != null
          ? ClinicsStatsModel.fromJson(
              json['clinics'],
            )
          : null,
      appointments:
          json['appointments'] != null
              ? AppointmentsStatsModel
                  .fromJson(
                  json['appointments'],
                )
              : null,
    );
  }
}

class ClinicsStatsModel
    extends ClinicsStatsEntity {
  const ClinicsStatsModel({
    super.total,
    super.active,
    super.inactive,
    super.open,
    super.closed,
    super.avgRating,
  });

  factory ClinicsStatsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClinicsStatsModel(
      total: json['total'],
      active: json['active'],
      inactive: json['inactive'],
      open: json['open'],
      closed: json['closed'],
      avgRating:
          json['avg_rating'] != null
              ? double.tryParse(
                  json['avg_rating']
                      .toString(),
                )
              : null,
    );
  }
}

class AppointmentsStatsModel
    extends AppointmentsStatsEntity {
  const AppointmentsStatsModel({
    super.total,
    super.pending,
    super.confirmed,
    super.cancelled,
    super.completed,
  });

  factory AppointmentsStatsModel
      .fromJson(
    Map<String, dynamic> json,
  ) {
    return AppointmentsStatsModel(
      total: json['total'],
      pending: json['pending'],
      confirmed: json['confirmed'],
      cancelled: json['cancelled'],
      completed: json['completed'],
    );
  }
}