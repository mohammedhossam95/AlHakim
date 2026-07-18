import 'package:equatable/equatable.dart';

class AppConfigEntity extends Equatable {
  final AppUpdateEntity? update;
  final AppBusinessEntity? business;
  final List<ExternalLinkEntity>? externalLinks;

  const AppConfigEntity({
    this.update,
    this.business,
    this.externalLinks,
  });

  @override
  List<Object?> get props => [update, business, externalLinks];
}

class AppUpdateEntity extends Equatable {
  final String? type;
  final String? latestVersion;
  final String? minimumSupportedVersion;
  final String? storeUrl;

  const AppUpdateEntity({
    this.type,
    this.latestVersion,
    this.minimumSupportedVersion,
    this.storeUrl,
  });

  @override
  List<Object?> get props => [
        type,
        latestVersion,
        minimumSupportedVersion,
        storeUrl,
      ];
}

class AppBusinessEntity extends Equatable {
  final String? commercialRegistrationNumber;

  const AppBusinessEntity({this.commercialRegistrationNumber});

  @override
  List<Object?> get props => [commercialRegistrationNumber];
}

class ExternalLinkEntity extends Equatable {
  final String? name;
  final String? icon;
  final String? url;

  const ExternalLinkEntity({
    this.name,
    this.icon,
    this.url,
  });

  @override
  List<Object?> get props => [name, icon, url];
}
