import 'package:equatable/equatable.dart';

class SettingEntity extends Equatable {
  final int? id;
  final String? appName;
  final String? contactEmail;
  final String? contactPhone;
  final String? whatsapp;
  final String? facebook;
  final String? instagram;
  final String? tiktok;
  final String? twitter;
  final String? snapchat;
  final int? returnDays;
  final String? deliveryPeriod;
  final int? smsCodeOptions;
  final String? simpleAbout;
  final String? image;
  final String? favIco;
  final int? defaultLang;
  final dynamic taxNumber;
  final String? appVersion;
  final int? vat;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SettingEntity({
    this.id,
    this.appName,
    this.contactEmail,
    this.contactPhone,
    this.whatsapp,
    this.facebook,
    this.instagram,
    this.tiktok,
    this.twitter,
    this.snapchat,
    this.returnDays,
    this.deliveryPeriod,
    this.smsCodeOptions,
    this.simpleAbout,
    this.image,
    this.favIco,
    this.defaultLang,
    this.taxNumber,
    this.appVersion,
    this.createdAt,
    this.updatedAt,
    this.vat,
  });

  @override
  List<Object?> get props => [
    id,
    appName,
    contactEmail,
    contactPhone,
    whatsapp,
    facebook,
    instagram,
    tiktok,
    twitter,
    snapchat,
    returnDays,
    deliveryPeriod,
    smsCodeOptions,
    simpleAbout,
    image,
    favIco,
    defaultLang,
    taxNumber,
    appVersion,
    createdAt,
    updatedAt,
    vat,
  ];
}
