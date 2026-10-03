import 'package:equatable/equatable.dart';

/// Ratings are 1-5 stars.
///
/// TODO: confirm the field names with the backend once the endpoint is ready.
class RateAppointmentParams extends Equatable {
  final int appointmentId;
  final int doctorRating;
  final int secretaryRating;
  final int clinicRating;
  final int appRating;
  final String? notes;

  const RateAppointmentParams({
    required this.appointmentId,
    required this.doctorRating,
    required this.secretaryRating,
    required this.clinicRating,
    required this.appRating,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'doctor_rating': doctorRating,
      'secretary_rating': secretaryRating,
      'clinic_rating': clinicRating,
      'app_rating': appRating,
    };

    if (notes != null && notes!.trim().isNotEmpty) {
      data['notes'] = notes!.trim();
    }

    return data;
  }

  @override
  List<Object?> get props => [
    appointmentId,
    doctorRating,
    secretaryRating,
    clinicRating,
    appRating,
    notes,
  ];
}
