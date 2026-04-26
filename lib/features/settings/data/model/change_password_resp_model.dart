import '/core/base_classes/base_one_response.dart';

class SettingChangePasswordRespModel extends BaseOneResponse {
  const SettingChangePasswordRespModel({super.message});

  factory SettingChangePasswordRespModel.fromJson(Map<String, dynamic> json) {
    return SettingChangePasswordRespModel(message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
