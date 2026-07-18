import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/settings/domain/entity/app_setting_entity.dart';

class AppSettingRespModel extends BaseOneResponse {
  const AppSettingRespModel({super.status, super.message, super.data});

  factory AppSettingRespModel.fromJson(Map<String, dynamic> json) {
    return AppSettingRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null
          ? null
          : AppConfigModel.fromJson(json['data']),
    );
  }
}

class AppConfigModel extends AppConfigEntity {
  const AppConfigModel({
    super.update,
    super.business,
    super.externalLinks,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      update: json['update'] == null
          ? null
          : AppUpdateModel.fromJson(json['update']),
      business: json['business'] == null
          ? null
          : AppBusinessModel.fromJson(json['business']),
      externalLinks: json['external_links'] == null
          ? []
          : List<ExternalLinkModel>.from(
              (json['external_links'] as List).map(
                (x) => ExternalLinkModel.fromJson(x),
              ),
            ),
    );
  }
}

class AppUpdateModel extends AppUpdateEntity {
  const AppUpdateModel({
    super.type,
    super.latestVersion,
    super.minimumSupportedVersion,
    super.storeUrl,
  });

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) {
    return AppUpdateModel(
      type: json['type']?.toString(),
      latestVersion: json['latest_version']?.toString(),
      minimumSupportedVersion:
          json['minimum_supported_version']?.toString(),
      storeUrl: json['store_url']?.toString(),
    );
  }
}

class AppBusinessModel extends AppBusinessEntity {
  const AppBusinessModel({super.commercialRegistrationNumber});

  factory AppBusinessModel.fromJson(Map<String, dynamic> json) {
    return AppBusinessModel(
      commercialRegistrationNumber:
          json['commercial_registration_number']?.toString(),
    );
  }
}

class ExternalLinkModel extends ExternalLinkEntity {
  const ExternalLinkModel({
    super.name,
    super.icon,
    super.url,
  });

  factory ExternalLinkModel.fromJson(Map<String, dynamic> json) {
    return ExternalLinkModel(
      name: json['name']?.toString(),
      icon: json['icon']?.toString(),
      url: json['url']?.toString(),
    );
  }
}
