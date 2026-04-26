import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/settings/domain/entity/app_setting_entity.dart';

class AppSettingRespModel extends BaseListResponse {
  const AppSettingRespModel({super.success, super.data, super.message});

  factory AppSettingRespModel.fromJson(Map<String, dynamic> json) {
    return AppSettingRespModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((item) => AppSettingsModel.fromJson(item))
                .toList()
          : [],
    );
  }
}

class AppSettingsModel extends AppSettingsEntity {
  const AppSettingsModel({
    super.id,
    super.key,
    super.value,
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
    super.simpleAbout,
    super.taxNumber,
    super.image,
    super.favIco,
    super.defaultLang,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      id: json['id'] as int?,
      key: json['key'],
      value: json['value'],
      appName: json['app_name'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      tiktok: json['tiktok'] as String?,
      twitter: json['twitter'] as String?,
      snapchat: json['snapchat'] as String?,
      returnDays: json['return_days'] as int?,
      deliveryPeriod: json['delivery_period'] as String?,
      simpleAbout: json['simple_about'] as String?,
      taxNumber: json['tax_number']?.toString(),
      image: json['image'] as String?,
      favIco: json['fav_ico'] as String?,
      defaultLang: json['default_lang'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'value': value,
      'app_name': appName,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'whatsapp': whatsapp,
      'facebook': facebook,
      'instagram': instagram,
      'tiktok': tiktok,
      'twitter': twitter,
      'snapchat': snapchat,
      'return_days': returnDays,
      'delivery_period': deliveryPeriod,
      'simple_about': simpleAbout,
      'tax_number': taxNumber,
      'image': image,
      'fav_ico': favIco,
      'default_lang': defaultLang,
    };
  }
}
