import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';


/// ===========================================================================
/// Auth Response Model
/// ===========================================================================
class AuthRespModel extends BaseOneResponse {
  final String? tokenType;
  final String? token;

  const AuthRespModel({
    super.data,
    super.status,
    super.message,
    this.tokenType,
    this.token,
  });

  factory AuthRespModel.fromJson(Map<String, dynamic> json) {
    dynamic dataNode = json["data"];
    UserModel? userModel;
    String? extractedToken;
    String? extractedTokenType;

    if (dataNode != null && dataNode is Map<String, dynamic>) {
      // CASE 1: Teacher/Instructor (Nested structure: data -> user)
      if (dataNode.containsKey('user')) {
        userModel = UserModel.fromJson(dataNode['user']);
        extractedToken = dataNode['token'];
        extractedTokenType = dataNode['token_type'];
      }
      // CASE 2: Student/Parent (Flat structure: data -> {fields})
      else {
        userModel = UserModel.fromJson(dataNode);
        // Sometimes tokens are at the root or inside data
        extractedToken = dataNode['token'] ?? json['token'];
        extractedTokenType = dataNode['token_type'] ?? json['token_type'];
      }
    }

    return AuthRespModel(
      data: userModel,
      message: json["message"],
      status: json["status"],
      token: extractedToken,
      tokenType: extractedTokenType,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> base = {"status": status, "message": message};

    if (data != null && data is UserModel) {
      base["data"] = {
        "token": token,
        "token_type": tokenType,
        "user": (data as UserModel).toJson(),
      };
    }
    return base;
  }
}

/// ===========================================================================
/// User Model
/// ===========================================================================
class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.name,
    super.email,
    super.phone,
    super.parentPhone,
    super.role,
    super.tenantId,
    super.tenantName,
    super.activationStatus,
    super.profileImageUrl,
    super.subscriptionType,
    super.createdAt,
    super.dateOfBirth,
    super.address,
    super.schoolName,
    super.parentJob,
    super.notes,
    super.governorate,
    super.grade,
    super.tenant,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    parentPhone: json['parent_phone']?.toString(), // تأكد من تحويلها لنص
    role: json['role'],
    tenantId: json['tenant_id'] ?? json['tenant']?['id'],
    tenantName: json['tenant_name'] ?? json['tenant']?['name'],
    activationStatus: json['activation_status'] == 1 || 
                      json['activation_status'] == '1' || 
                      json['activation_status'] == true,
    profileImageUrl: json['profile_image_url'],
    subscriptionType: json['subscription_type'],
    createdAt: json['created_at'],
    dateOfBirth: json['date_of_birth'],
    address: json['address']?.toString(),
    schoolName: json['school_name']?.toString(),
    parentJob: json['parent_job']?.toString(),
    notes: json['notes']?.toString(),
    governorate: json['governorate'] != null 
        ? GovernorateModel.fromJson(json['governorate']) 
        : null,
    grade: json['grade'] != null 
        ? GradeModel.fromJson(json['grade']) 
        : null,
    tenant: json['tenant'] != null 
        ? TenantModel.fromJson(json['tenant']) 
        : null,
  );
}

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'parent_phone': parentPhone,
    'role': role,
    'tenant_id': tenantId,
    'activation_status': activationStatus,
    'profile_image_url': profileImageUrl,
    'date_of_birth': dateOfBirth,
    'address': address,
    'school_name': schoolName,
    'parent_job': parentJob,
    'notes': notes,
    'governorate': governorate is GovernorateModel
        ? (governorate as GovernorateModel).toJson()
        : null,
    'grade': grade is GradeModel ? (grade as GradeModel).toJson() : null,
  };
}

/// ===========================================================================
/// Supporting Models
/// ===========================================================================

class TenantModel extends TenantEntity {
  const TenantModel({
    super.id,
    super.name,
    super.subscriptionType,
    super.multipleTeacher,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'],
      name: json['name'],
      subscriptionType: json['subscription_type'],
      multipleTeacher:
          json['multiple_teacher'] == 1 || json['multiple_teacher'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subscription_type': subscriptionType,
    'multiple_teacher': multipleTeacher,
  };
}

class GovernorateModel extends GovernorateEntity {
  const GovernorateModel({super.id, super.name});
  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      GovernorateModel(id: json['id'], name: json['name']);
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class GradeModel extends GradeEntity {
  const GradeModel({super.id, super.name});
  factory GradeModel.fromJson(Map<String, dynamic> json) =>
      GradeModel(id: json['id'], name: json['name']);
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
