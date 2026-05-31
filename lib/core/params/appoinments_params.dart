import 'package:equatable/equatable.dart';

class AppoinmentsParams extends Equatable {
  final String? doctorId;
  final String? appointmentDate;

  const AppoinmentsParams({this.doctorId, this.appointmentDate});

  @override
  List<Object?> get props => [doctorId, appointmentDate];
}
