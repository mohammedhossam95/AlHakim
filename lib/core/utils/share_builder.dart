import 'dart:io';

import 'package:alhakim/core/utils/app_strings.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/settings/domain/entity/hospital_emergency_entity.dart';
import 'package:flutter/material.dart';

class ShareTextBuilder {
  ShareTextBuilder._();

  /// Required on iOS/iPad for the share sheet popover anchor.
  static Rect sharePositionOrigin(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final size = box.size;
      if (size.width > 0 && size.height > 0) {
        return box.localToGlobal(Offset.zero) & size;
      }
    }
    final media = MediaQuery.sizeOf(context);
    return Rect.fromLTWH(media.width / 2, media.height / 2, 1, 1);
  }

  /// بناء نص مشاركة بيانات الدكتور
  static String buildDoctorShareText(DoctorEntity doctor) {
    final buffer = StringBuffer();

    buffer.writeln('👨‍⚕️ ${doctor.name?.ar ?? ''}');
    // ⚠️ عدّل .ar / .en على حسب فيلدز NameEntity الفعلية عندك
    if (doctor.specialty?.name != null) {
      buffer.writeln('🩺 التخصص: ${doctor.specialty!.name}');
      // ⚠️ عدّل حسب فيلدز DoctorSpecialtyEntity
    }

    if (doctor.bio != null && doctor.bio!.ar != null) {
      buffer.writeln(doctor.bio!.ar ?? '');
    }

    if (doctor.location?.city != null) {
      buffer.writeln(
        '📍 العنوان: ${doctor.location!.street}, ${doctor.location!.district}, ${doctor.location!.city}',
      );
      // ⚠️ عدّل حسب فيلدز LocationEntity
    }

    if (doctor.secretaryPhone?.isNotEmpty ?? false) {
      buffer.writeln(
        '📞 تليفون العيادة: ${doctor.secretaryCountryCode ?? doctor.medicalCenter?.countryCode ?? "20"}${doctor.secretaryPhone ?? doctor.medicalCenter?.phone ?? ""}',
      );
    }
    if (doctor.latitude != null && doctor.longitude != null) {
      buffer.writeln(
        '🗺️ الموقع على الخريطة: https://maps.google.com/?q=${doctor.latitude},${doctor.longitude}',
      );
    }

    buffer.writeln();
    buffer.writeln('حمّل تطبيق الحكيم دلوقتي وابدأ احجز مع أفضل الدكاترة:');
    buffer.writeln(
      Platform.isAndroid
          ? AppStrings.androidDownloadLink
          : AppStrings.iOSdownloadLink,
    );

    return buffer.toString();
  }

  /// بناء نص مشاركة بيانات مستشفى / مركز طبي / طوارئ
  static String buildFacilityShareText(HospitalEmergencyEntity item) {
    final buffer = StringBuffer();

    buffer.writeln('🏥 ${item.name ?? ''}');

    if (item.description?.isNotEmpty ?? false) {
      buffer.writeln('ℹ️ ${item.description}');
    }

    if (item.location?.isNotEmpty ?? false) {
      buffer.writeln('📍 العنوان: \n${item.location}');
    }

    if (item.number?.isNotEmpty ?? false) {
      buffer.writeln('📞 الرقم: ${item.number}');
    }

    if (item.lat != null && item.lng != null) {
      buffer.writeln(
        '🗺️ الموقع على الخريطة: https://maps.google.com/?q=${item.lat},${item.lng}',
      );
    }
    if (item.tags?.isNotEmpty ?? false) {
      buffer.writeln('🏷️ ${item.tags!.join(' - ')}');
    }

    buffer.writeln();
    buffer.writeln(
      'حمّل تطبيق الحكيم دلوقتي علشان توصل بسرعة لأقرب مستشفى أو طوارئ:',
    );
    buffer.writeln(
      Platform.isAndroid
          ? AppStrings.androidDownloadLink
          : AppStrings.iOSdownloadLink,
    );

    return buffer.toString();
  }
}
