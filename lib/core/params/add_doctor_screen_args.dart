import 'package:alhakim/core/utils/enums.dart';
import 'package:equatable/equatable.dart';

class AddDoctorScreenArgs extends Equatable {
  final DoctorFormSource source;
  final int? medicalCenterId;

  const AddDoctorScreenArgs({
    this.source = DoctorFormSource.delegate,
    this.medicalCenterId,
  });

  @override
  List<Object?> get props => [source, medicalCenterId];
}
