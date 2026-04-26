import '/core/base_classes/base_one_response.dart';

class ContactUsRespModel extends BaseOneResponse {
  const ContactUsRespModel({super.message, super.success});
  factory ContactUsRespModel.fromJson(Map<String, dynamic> json) {
    return ContactUsRespModel(success: json['success'], message: json['message']);
  }
}
