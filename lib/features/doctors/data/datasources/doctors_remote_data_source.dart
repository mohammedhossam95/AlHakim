import 'dart:io';

import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/params/add_doctor_params.dart';
import 'package:alhakim/core/params/appoinments_params.dart';
import 'package:alhakim/core/params/reschedule_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/features/doctors/data/models/doctor_appoinments_for_day_model.dart';
import 'package:alhakim/features/doctors/data/models/doctor_home_model.dart';
import 'package:alhakim/features/doctors/data/models/doctor_model.dart';
import 'package:alhakim/features/doctors/data/models/reschedule_model.dart';
import 'package:alhakim/injection_container.dart';
import 'package:dio/dio.dart';

abstract class DoctorRemoteDataSource {
  Future<DoctorsRespModel> getDoctors({String? search, int? perPage});
  Future<DoctorsRespModel> getRemoteMedicalCenterDoctors(int id);
  Future<BaseOneResponse> addDoctor(AddDoctorParams params);
  Future<BaseOneResponse> updateDoctor(AddDoctorParams params);
  Future<BaseOneResponse> deleteDoctor(String id);
  Future<BaseOneResponse> toggleDoctorStatus({required String id});
  Future<BaseOneResponse> closeClinicToday({required String doctorId});
  Future<BaseOneResponse> toggleClinic({required String doctorId});
  Future<DoctorHomeRespModel> getDoctorHome(String id);
  Future<DoctorAppoinmentsForDayRespModel> getDoctorAppoinmentsForDay({
    required AppoinmentsParams params,
  });
  Future<RescheduleRespModel> reschedule({required RescheduleParams params});
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  @override
  Future<DoctorsRespModel> getDoctors({String? search, int? perPage}) async {
    try {
      final endPoint = sessionCubit.state.userType == UserType.delegate
          ? '/representative/doctors'
          : '/doctors';
      final response = await dioConsumer.get(
        endPoint,
        queryParameters: {
          'per_page': ?perPage,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      if (response['status'] == true) {
        return DoctorsRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DoctorsRespModel> getRemoteMedicalCenterDoctors(int id) async {
    try {
      final endPoint = '/medical-centers/$id/doctors';

      final response = await dioConsumer.get(endPoint);

      if (response['status'] == true) {
        return DoctorsRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> addDoctor(AddDoctorParams params) async {
    try {
      FormData formData = FormData();

      formData.fields.add(
        MapEntry("price_hidden", params.hidePrice == true ? "1" : "0"),
      );

      formData.fields.add(
        MapEntry(
          "consultation_price_hidden",
          params.hideConsultationPrice == true ? "1" : "0",
        ),
      );

      if (params.nameEn != null) {
        formData.fields.add(MapEntry("translations[en][name]", params.nameEn!));
      }

      if (params.bioEn != null) {
        formData.fields.add(MapEntry("translations[en][bio]", params.bioEn!));
      }

      if (params.nameAr != null) {
        formData.fields.add(MapEntry("translations[ar][name]", params.nameAr!));
      }

      if (params.bioAr != null) {
        formData.fields.add(MapEntry("translations[ar][bio]", params.bioAr!));
      }

      if (params.specialtyId != null) {
        formData.fields.add(
          MapEntry("specialty_id", params.specialtyId.toString()),
        );
      }

      if (params.professionalRegistrationNumber != null) {
        formData.fields.add(
          MapEntry(
            "professional_registration_number",
            params.professionalRegistrationNumber!,
          ),
        );
      }

      if (params.academicDegree != null) {
        formData.fields.add(
          MapEntry("academic_degree", params.academicDegree!),
        );
      }
      if (params.secretaryCountryCode != null) {
        formData.fields.add(
          MapEntry("secretary_country_code", params.secretaryCountryCode!),
        );
      }

      if (params.secretaryPhone != null) {
        formData.fields.add(
          MapEntry("secretary_phone", params.secretaryPhone!),
        );
      }

      if (params.clinicCountryCode != null) {
        formData.fields.add(
          MapEntry("clinic_country_code", params.clinicCountryCode!),
        );
      }
      if (params.clinicPhone != null) {
        formData.fields.add(MapEntry("clinic_phone", params.clinicPhone!));
      }

      if (params.minPatients != null) {
        formData.fields.add(MapEntry("min_patients", params.minPatients!));
      }

      if (params.representativeCode != null) {
        formData.fields.add(
          MapEntry("representative_code", params.representativeCode!),
        );
      }

      if (params.medicalCenterId != null) {
        formData.fields.add(
          MapEntry("medical_center_id", params.medicalCenterId.toString()),
        );
      }

      if (params.price != null) {
        formData.fields.add(MapEntry("price", params.price!));
      }

      if (params.consultationPrice != null) {
        formData.fields.add(
          MapEntry("consultation_price", params.consultationPrice!),
        );
      }

      if (params.profileImage != null) {
        final compressedImage = await Constants.getCompressedFile(
          params.profileImage!,
          "${params.profileImage!.path}_compressed.jpg",
        );

        final imageFile = compressedImage ?? params.profileImage!;

        formData.files.add(
          MapEntry(
            "profile_image",
            await MultipartFile.fromFile(imageFile.path),
          ),
        );
      }
      if (params.license != null) {
        File file = params.license!;

        if (!Constants.checkPDFFiles(file.path)) {
          final compressedFile = await Constants.getCompressedFile(
            file,
            "${file.path}_compressed.jpg",
          );

          file = compressedFile ?? file;
        }

        formData.files.add(
          MapEntry("license", await MultipartFile.fromFile(file.path)),
        );
      }

      /// schedules
      if (params.schedules != null && params.schedules!.isNotEmpty) {
        for (int i = 0; i < params.schedules!.length; i++) {
          final schedule = params.schedules![i];

          if (schedule['day_of_week'] != null) {
            formData.fields.add(
              MapEntry(
                "schedules[$i][day_of_week]",
                schedule['day_of_week'].toString(),
              ),
            );
          }

          if (schedule['start_time'] != null) {
            formData.fields.add(
              MapEntry("schedules[$i][start_time]", schedule['start_time']),
            );
          }

          if (schedule['end_time'] != null) {
            formData.fields.add(
              MapEntry("schedules[$i][end_time]", schedule['end_time']),
            );
          }

          if (schedule['slot_duration'] != null) {
            formData.fields.add(
              MapEntry(
                "schedules[$i][slot_duration]",
                schedule['slot_duration'].toString(),
              ),
            );
          }
        }
      }
      final response = await dioConsumer.post('/doctors', formData: formData);

      if (response['status'] == true) {
        return BaseOneResponse.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> deleteDoctor(String id) async {
    try {
      final response = await dioConsumer.delete('/doctors/$id');

      if (response['status'] == true) {
        return BaseOneResponse.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> updateDoctor(AddDoctorParams params) async {
    try {
      FormData formData = FormData();

      formData.fields.add(const MapEntry("_method", "PUT"));

      if (params.nameEn != null) {
        formData.fields.add(MapEntry("translations[en][name]", params.nameEn!));
      }

      if (params.bioEn != null) {
        formData.fields.add(MapEntry("translations[en][bio]", params.bioEn!));
      }

      if (params.nameAr != null) {
        formData.fields.add(MapEntry("translations[ar][name]", params.nameAr!));
      }

      if (params.bioAr != null) {
        formData.fields.add(MapEntry("translations[ar][bio]", params.bioAr!));
      }

      if (params.specialtyId != null) {
        formData.fields.add(
          MapEntry("specialty_id", params.specialtyId.toString()),
        );
      }

      if (params.professionalRegistrationNumber != null) {
        formData.fields.add(
          MapEntry(
            "professional_registration_number",
            params.professionalRegistrationNumber!,
          ),
        );
      }

      if (params.academicDegree != null) {
        formData.fields.add(
          MapEntry("academic_degree", params.academicDegree!),
        );
      }

      if (params.clinicPhone != null) {
        formData.fields.add(MapEntry("clinic_phone", params.clinicPhone!));
      }

      if (params.secretaryPhone != null) {
        formData.fields.add(
          MapEntry("secretary_phone", params.secretaryPhone!),
        );
      }

      if (params.minPatients != null) {
        formData.fields.add(MapEntry("min_patients", params.minPatients!));
      }

      if (params.representativeCode != null) {
        formData.fields.add(
          MapEntry("representative_code", params.representativeCode!),
        );
      }

      if (params.price != null) {
        formData.fields.add(MapEntry("price", params.price!));
      }

      if (params.consultationPrice != null) {
        formData.fields.add(
          MapEntry("consultation_price", params.consultationPrice!),
        );
      }
      if (params.hidePrice != null) {
        formData.fields.add(
          MapEntry("price_hidden", params.hidePrice == true ? "1" : "0"),
        );
      }
      if (params.hideConsultationPrice != null) {
        formData.fields.add(
          MapEntry(
            "consultation_price_hidden",
            params.hideConsultationPrice == true ? "1" : "0",
          ),
        );
      }
      if (params.profileImage != null) {
        final compressedImage = await Constants.getCompressedFile(
          params.profileImage!,
          "${params.profileImage!.path}_compressed.jpg",
        );

        final imageFile = compressedImage ?? params.profileImage!;

        formData.files.add(
          MapEntry(
            "profile_image",
            await MultipartFile.fromFile(imageFile.path),
          ),
        );
      }
      if (params.license != null) {
        File file = params.license!;

        if (!Constants.checkPDFFiles(file.path)) {
          final compressedFile = await Constants.getCompressedFile(
            file,
            "${file.path}_compressed.jpg",
          );

          file = compressedFile ?? file;
        }

        formData.files.add(
          MapEntry("license", await MultipartFile.fromFile(file.path)),
        );
      }

      if (params.schedules != null && params.schedules!.isNotEmpty) {
        for (int i = 0; i < params.schedules!.length; i++) {
          final schedule = params.schedules![i];

          if (schedule['day_of_week'] != null) {
            formData.fields.add(
              MapEntry(
                "schedules[$i][day_of_week]",
                schedule['day_of_week'].toString(),
              ),
            );
          }

          if (schedule['start_time'] != null) {
            formData.fields.add(
              MapEntry("schedules[$i][start_time]", schedule['start_time']),
            );
          }

          if (schedule['end_time'] != null) {
            formData.fields.add(
              MapEntry("schedules[$i][end_time]", schedule['end_time']),
            );
          }

          if (schedule['slot_duration'] != null) {
            formData.fields.add(
              MapEntry(
                "schedules[$i][slot_duration]",
                schedule['slot_duration'].toString(),
              ),
            );
          }
          if (params.secretaryCountryCode != null) {
            formData.fields.add(
              MapEntry("secretary_country_code", params.secretaryCountryCode!),
            );
          }

          if (params.clinicCountryCode != null) {
            formData.fields.add(
              MapEntry("clinic_country_code", params.clinicCountryCode!),
            );
          }
        }
      }
      final response = await dioConsumer.post(
        '/doctors/${params.id}',
        formData: formData,
      );

      if (response['status'] == true) {
        return BaseOneResponse.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> toggleDoctorStatus({required String id}) async {
    try {
      final endpoint = '/doctors/$id/deactivate';
      final FormData formData = FormData.fromMap({"_method": "PATCH"});
      final response = await dioConsumer.post(endpoint, formData: formData);

      if (response['status'] == true) {
        return BaseOneResponse.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> closeClinicToday({required String doctorId}) async {
    try {
      final response = await dioConsumer.post('/doctors/$doctorId/close-today');

      if (response['status'] == true) {
        return BaseOneResponse(
          status: response['status'],
          message: response['message'],
        );
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> toggleClinic({required String doctorId}) async {
    try {
      final response = await dioConsumer.post(
        '/doctors/$doctorId/toggle-clinic',

        formData: FormData.fromMap({"_method": "PATCH"}),
      );

      if (response['status'] == true) {
        return BaseOneResponse(
          status: response['status'],
          message: response['message'],
        );
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DoctorHomeRespModel> getDoctorHome(String id) async {
    try {
      final response = await dioConsumer.get('/doctors/$id/home');

      if (response['status'] == true) {
        return DoctorHomeRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DoctorAppoinmentsForDayRespModel> getDoctorAppoinmentsForDay({
    required AppoinmentsParams params,
  }) async {
    try {
      final response = await dioConsumer.get(
        '/doctors/${params.doctorId}/appointments',

        queryParameters: {"appointment_date": params.appointmentDate},
      );

      if (response['status'] == true) {
        return DoctorAppoinmentsForDayRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RescheduleRespModel> reschedule({
    required RescheduleParams params,
  }) async {
    try {
      final response = await dioConsumer.post(
        '/doctors/${params.doctorId}/re-schedule',

        formData: FormData.fromMap(params.toJson()),
      );

      if (response['status'] == true) {
        return RescheduleRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }
}
