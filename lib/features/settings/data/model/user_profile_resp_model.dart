import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';

import '/core/base_classes/base_one_response.dart';

class UserProfileRespModel extends BaseOneResponse {
  const UserProfileRespModel({super.data, super.success});

  factory UserProfileRespModel.fromJson(Map<String, dynamic> json) =>
      UserProfileRespModel(
        data: json["data"] != null
            ? UserModel.fromJson(json["data"])
            : UserModel(),
        success: json["success"],
      );
}
