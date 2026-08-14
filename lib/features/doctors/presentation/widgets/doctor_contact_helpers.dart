import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/share_builder.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

mixin DoctorContactHelpers {
  DoctorEntity get doctor;

  String get doctorDisplayName => appLocalizations.isArLocale
      ? doctor.name?.ar ?? ''
      : doctor.name?.en ?? '';

  String get contactPhone {
    final countryCode =
        doctor.secretaryCountryCode ??
        doctor.medicalCenter?.countryCode ??
        '20';
    final phone = doctor.secretaryPhone ?? doctor.medicalCenter?.phone ?? '';
    return _composeInternationalPhone(countryCode: countryCode, phone: phone);
  }

  /// Prefer dedicated WhatsApp fields; fall back to clinic contact phone.
  String get whatsappPhone {
    final countryCode =
        doctor.whatsappCountryCode ??
        doctor.secretaryCountryCode ??
        doctor.medicalCenter?.countryCode ??
        '20';
    final phone =
        doctor.whatsappNumber ??
        doctor.secretaryPhone ??
        doctor.medicalCenter?.phone ??
        '';
    return _composeInternationalPhone(countryCode: countryCode, phone: phone);
  }

  /// Builds E.164-style digits for wa.me (no +, no leading 0 on national number).
  String _composeInternationalPhone({
    required String countryCode,
    required String phone,
  }) {
    final codeDigits = countryCode.replaceAll(RegExp(r'[^\d]'), '');
    var phoneDigits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (phoneDigits.isEmpty) return '';

    // Already includes country code (e.g. 2010xxxxxxxx).
    if (codeDigits.isNotEmpty && phoneDigits.startsWith(codeDigits)) {
      return phoneDigits;
    }

    // Strip national trunk prefix (e.g. 010... → 10...).
    if (phoneDigits.startsWith('0')) {
      phoneDigits = phoneDigits.substring(1);
    }

    return '$codeDigits$phoneDigits';
  }

  (double, double)? get mapCoordinates {
    final candidates = <(String?, String?)>[
      (doctor.latitude, doctor.longitude),
      (doctor.location?.latitude, doctor.location?.longitude),
      (doctor.medicalCenter?.latitude, doctor.medicalCenter?.longitude),
    ];

    for (final pair in candidates) {
      final lat = double.tryParse(pair.$1 ?? '');
      final lng = double.tryParse(pair.$2 ?? '');
      if (lat != null && lng != null) {
        return (lat, lng);
      }
    }
    return null;
  }

  Future<void> openMaps() async {
    final coords = mapCoordinates;
    if (coords == null) return;
    await Constants.openGoogleMaps(lat: coords.$1, lng: coords.$2);
  }

  Future<void> openWhatsApp() async {
    await Constants.openWhatsApp(whatsappPhone);
  }

  Future<void> callDoctor() async {
    await Constants.makePhoneCall(contactPhone);
  }

  Future<void> shareDoctor(BuildContext context) async {
    await SharePlus.instance.share(
      ShareParams(
        text: ShareTextBuilder.buildDoctorShareText(doctor),
        subject: 'مشاركة بيانات دكتور - تطبيق الحكيم',
        sharePositionOrigin: ShareTextBuilder.sharePositionOrigin(context),
      ),
    );
  }
}
