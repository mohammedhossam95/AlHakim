import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:equatable/equatable.dart';

class UserAuthEntity extends Equatable {
  final String? token;
  final String? role;
  final UserEntity? user;
  final DoctorEntity? doctor;
  final String? nextStep;

  const UserAuthEntity({
    this.token,
    this.role,
    this.user,
    this.doctor,
    this.nextStep,
  });

  @override
  List<Object?> get props => [token, role, user, doctor, nextStep];
}
