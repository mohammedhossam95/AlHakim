import 'package:equatable/equatable.dart';

class AppSettingsEntity extends Equatable {
  final int? id;
  final String? key;
  final String? value;
  final String? appName;
  final String? contactEmail;
  final String? contactPhone;
  final String? whatsapp;
  final String? facebook;
  final String? instagram;
  final String? tiktok;
  final String? twitter; // New
  final String? snapchat; // New
  final int? returnDays; // New
  final String? deliveryPeriod; // New
  final String? simpleAbout; // New
  final dynamic taxNumber; // Changed to dynamic or String to be safe
  final String? image;
  final String? favIco;
  final int? defaultLang;

  const AppSettingsEntity({
    this.id,
    this.key,
    this.value,
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
    this.simpleAbout,
    this.taxNumber,
    this.image,
    this.favIco,
    this.defaultLang,
  });

  @override
  List<Object?> get props => [
    id,
    key,
    value,
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
    simpleAbout,
    taxNumber,
    image,
    favIco,
    defaultLang,
  ];
}
