import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/share_builder.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/injection_container.dart';
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
    return '$countryCode$phone';
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
    await Constants.openWhatsApp(contactPhone);
  }

  Future<void> callDoctor() async {
    await Constants.makePhoneCall(contactPhone);
  }

  Future<void> shareDoctor() async {
    await SharePlus.instance.share(
      ShareParams(
        text: ShareTextBuilder.buildDoctorShareText(doctor),
        subject: 'مشاركة بيانات دكتور - تطبيق الحكيم',
      ),
    );
  }
}
