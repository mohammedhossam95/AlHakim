import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/features/doctors/domain/entities/profile_entity.dart';
import 'package:equatable/equatable.dart';

class AddDoctorScreenArgs extends Equatable {
  final DoctorFormSource source;
  final ProfileEntity? medicalCenterProfile;

  const AddDoctorScreenArgs({
    this.source = DoctorFormSource.delegate,
    this.medicalCenterProfile,
  });

  @override
  List<Object?> get props => [source, medicalCenterProfile];
}
