import '/core/base_classes/base_list_response.dart';

class SettingChangePasswordRespModel extends BaseListResponse {
  const SettingChangePasswordRespModel({
    super.status,
    super.message,
    super.data,
  });

  factory SettingChangePasswordRespModel.fromJson(Map<String, dynamic> json) {
    return SettingChangePasswordRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null ? [] : List<dynamic>.from(json['data'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
