import 'package:alhakim/core/base_classes/base_one_response.dart';

class DeleteUserAccountRespModel extends BaseOneResponse {
  const DeleteUserAccountRespModel({super.status, super.message});
  factory DeleteUserAccountRespModel.fromJson(Map<String, dynamic> json) {
    return DeleteUserAccountRespModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
