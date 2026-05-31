import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/features/booking/data/models/appointment_booking_model.dart';
import 'package:alhakim/features/booking/data/models/family_member_model.dart';
import 'package:alhakim/features/booking/data/models/kinship_model.dart';
import 'package:alhakim/injection_container.dart';
import 'package:dio/dio.dart';

abstract class BookingRemoteDataSource {
  Future<KinshipRespModel> getKinships();
  Future<FamilyMemberRespModel> getFamilyMembers();

  Future<AddFamilyMemberRespModel> addFamilyMember({
    required String fullName,
    required String birthDate,
    required String kinship,
  });
  Future<AppointmentBookingRespModel> bookAppointment({
    required String doctorId,
    required String appointmentDate,
    String? familyMemberId,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  @override
  Future<KinshipRespModel> getKinships() async {
    try {
      final response = await dioConsumer.get('/kinships');

      if (response['status'] == true) {
        return KinshipRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FamilyMemberRespModel> getFamilyMembers() async {
    try {
      final response = await dioConsumer.get('/family-members');

      if (response['status'] == true) {
        return FamilyMemberRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AddFamilyMemberRespModel> addFamilyMember({
    required String fullName,
    required String birthDate,
    required String kinship,
  }) async {
    try {
      final response = await dioConsumer.post(
        '/family-members',

        formData: FormData.fromMap({
          "full_name": fullName,
          "birth_date": birthDate,
          "kinship": kinship,
        }),
      );

      if (response['status'] == true) {
        return AddFamilyMemberRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AppointmentBookingRespModel> bookAppointment({
    required String doctorId,
    required String appointmentDate,
    String? familyMemberId,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "doctor_id": doctorId,
        "appointment_date": appointmentDate,
      };

      if (familyMemberId != null) {
        body["family_member_id"] = familyMemberId;
      }

      final response = await dioConsumer.post(
        '/appointments',

        formData: FormData.fromMap(body),
      );

      if (response['status'] == true) {
        return AppointmentBookingRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }
}
