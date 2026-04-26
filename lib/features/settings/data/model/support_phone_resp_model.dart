import '/features/settings/domain/entity/support_phone_response.dart';

SupportPhoneRespModel getSupportPhoneFromJson(dynamic str) =>
    SupportPhoneRespModel.fromJson(str);

class SupportPhoneRespModel extends SupportPhoneResp {
  const SupportPhoneRespModel({super.key, super.value});

  factory SupportPhoneRespModel.fromJson(Map<String, dynamic> json) =>
      SupportPhoneRespModel(key: json["key"], value: json["value"]);

  Map<String, dynamic> toJson() => {"key": key, "value": value};
}
