import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/auth/domain/entities/setting_entity.dart';

class SettingRespModel extends BaseOneResponse {
  const SettingRespModel({super.success, super.data, super.message});
  factory SettingRespModel.fromJson(Map<String, dynamic> json) =>
      SettingRespModel(
        success: json["success"],
        data: json["data"] == null ? null : SettingModel.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class SettingModel extends SettingEntity {
  const SettingModel({
    super.id,
    super.appName,
    super.contactEmail,
    super.contactPhone,
    super.whatsapp,
    super.facebook,
    super.instagram,
    super.tiktok,
    super.twitter,
    super.snapchat,
    super.returnDays,
    super.deliveryPeriod,
    super.smsCodeOptions,
    super.simpleAbout,
    super.image,
    super.favIco,
    super.defaultLang,
    super.taxNumber,
    super.appVersion,
    super.createdAt,
    super.updatedAt,
    super.vat,
  });
  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      id: json["id"],
      appName: json["app_name"],
      contactEmail: json["contact_email"],
      contactPhone: json["contact_phone"],
      whatsapp: json["whatsapp"],
      facebook: json["facebook"],
      instagram: json["instagram"],
      tiktok: json["tiktok"],
      twitter: json["twitter"],
      snapchat: json["snapchat"],
      returnDays: json["return_days"],
      deliveryPeriod: json["delivery_period"],
      smsCodeOptions: json["sms_code_options"],
      simpleAbout: json["simple_about"],
      image: json["image"],
      favIco: json["fav_ico"],
      defaultLang: json["default_lang"],
      taxNumber: json["tax_number"],
      appVersion: json["app_version"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      vat: json["vat"],
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "app_name": appName,
    "contact_email": contactEmail,
    "contact_phone": contactPhone,
    "whatsapp": whatsapp,
    "facebook": facebook,
    "instagram": instagram,
    "tiktok": tiktok,
    "twitter": twitter,
    "snapchat": snapchat,
    "return_days": returnDays,
    "delivery_period": deliveryPeriod,
    "sms_code_options": smsCodeOptions,
    "simple_about": simpleAbout,
    "image": image,
    "fav_ico": favIco,
    "default_lang": defaultLang,
    "tax_number": taxNumber,
    "app_version": appVersion,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "vat": vat,
  };
}
