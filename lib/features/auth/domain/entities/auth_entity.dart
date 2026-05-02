import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? token;
  final String? tokenType;
  final UserEntity? user;

  const AuthEntity({this.token, this.tokenType, this.user});

  @override
  List<Object?> get props => [token, tokenType, user];
}

class UserEntity extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? parentPhone;
  final String? role;
  final int? tenantId;
  final String? tenantName;
  final bool? activationStatus;
  final String? subscriptionType;
  final String? profileImageUrl;
  final String? createdAt;
  final String? dateOfBirth;
  final String? address;
  final String? schoolName;
  final String? parentJob;
  final String? notes;
  final GovernorateEntity? governorate;
  final GradeEntity? grade;
  final TenantEntity? tenant; // أضفت الـ Tenant للمدرسين

  const UserEntity({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.parentPhone,
    this.role,
    this.tenantId,
    this.tenantName,
    this.activationStatus,
    this.subscriptionType,
    this.profileImageUrl,
    this.createdAt,
    this.dateOfBirth,
    this.address,
    this.schoolName,
    this.parentJob,
    this.notes,
    this.governorate,
    this.grade,
    this.tenant,
  });

  @override
  List<Object?> get props => [
    id, name, email, phone, parentPhone, role,
    tenantId, tenantName, activationStatus,   
    subscriptionType, profileImageUrl, createdAt,
    dateOfBirth, address, schoolName, parentJob,
    notes, governorate, grade, tenant,
  ];
}

class TenantEntity extends Equatable {
  final int? id;
  final String? name;
  final String? subscriptionType;
  final bool? multipleTeacher;

  const TenantEntity({
    this.id,
    this.name,
    this.subscriptionType,
    this.multipleTeacher,
  });

  @override
  List<Object?> get props => [id, name, subscriptionType, multipleTeacher];
}

class GovernorateEntity extends Equatable {
  final int? id;
  final String? name;

  const GovernorateEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}

class GradeEntity extends Equatable {
  final int? id;
  final String? name;

  const GradeEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
