import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/settings/domain/entity/app_setting_entity.dart';

class AppSettingRespModel extends BaseOneResponse {
  const AppSettingRespModel({super.status, super.message, super.data});

  factory AppSettingRespModel.fromJson(Map<String, dynamic> json) {
    return AppSettingRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null ? null : AppConfigModel.fromJson(json['data']),
    );
  }
}

class AppConfigModel extends AppConfigEntity {
  const AppConfigModel({super.update, super.business, super.externalLinks});

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

  Map<String, dynamic> toJson() => {
    'update': update is AppUpdateModel
        ? (update as AppUpdateModel).toJson()
        : update == null
        ? null
        : {
            'type': update?.type,
            'latest_version': update?.latestVersion,
            'minimum_supported_version': update?.minimumSupportedVersion,
            'store_url': update?.storeUrl,
            'under_review': update?.underReview,
          },
    'business': business is AppBusinessModel
        ? (business as AppBusinessModel).toJson()
        : business == null
        ? null
        : {
            'commercial_registration_number':
                business?.commercialRegistrationNumber,
          },
    'external_links': externalLinks
        ?.map(
          (e) => e is ExternalLinkModel
              ? e.toJson()
              : {
                  'name': e.name,
                  'icon': e.icon,
                  'url': e.url,
                },
        )
        .toList(),
  };
}

class AppUpdateModel extends AppUpdateEntity {
  const AppUpdateModel({
    super.type,
    super.latestVersion,
    super.minimumSupportedVersion,
    super.storeUrl,
    super.underReview,
  });

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) {
    return AppUpdateModel(
      type: json['type']?.toString(),
      latestVersion: json['latest_version']?.toString(),
      minimumSupportedVersion: json['minimum_supported_version']?.toString(),
      storeUrl: json['store_url']?.toString(),
      underReview: json['under_review'] == true ||
          json['under_review'] == 1 ||
          json['under_review'] == '1',
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'latest_version': latestVersion,
    'minimum_supported_version': minimumSupportedVersion,
    'store_url': storeUrl,
    'under_review': underReview,
  };
}

class AppBusinessModel extends AppBusinessEntity {
  const AppBusinessModel({super.commercialRegistrationNumber});

  factory AppBusinessModel.fromJson(Map<String, dynamic> json) {
    return AppBusinessModel(
      commercialRegistrationNumber: json['commercial_registration_number']
          ?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'commercial_registration_number': commercialRegistrationNumber,
  };
}

class ExternalLinkModel extends ExternalLinkEntity {
  const ExternalLinkModel({super.name, super.icon, super.url});

  factory ExternalLinkModel.fromJson(Map<String, dynamic> json) {
    return ExternalLinkModel(
      name: json['name']?.toString(),
      icon: json['icon']?.toString(),
      url: json['url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'icon': icon,
    'url': url,
  };
}
