import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/add_doctor_params.dart';
import 'package:alhakim/core/params/appoinments_params.dart';
import 'package:alhakim/core/params/reschedule_params.dart';
import 'package:dartz/dartz.dart';

abstract class DoctorRepository {
  Future<Either<Failure, BaseListResponse>> getDoctors({
    String? search,
    int? perPage,
  });
  Future<Either<Failure, BaseListResponse>> getMedicalCenterDoctors(int id);
  Future<Either<Failure, BaseOneResponse>> addDoctor(AddDoctorParams params);
  Future<Either<Failure, BaseOneResponse>> deleteDoctor(String id);
  Future<Either<Failure, BaseOneResponse>> updateDoctor(AddDoctorParams params);
  Future<Either<Failure, BaseOneResponse>> toggleDoctorStatus({
    required String id,
  });
  Future<Either<Failure, BaseOneResponse>> closeClinicToday({
    required String doctorId,
  });
  Future<Either<Failure, BaseOneResponse>> toggleClinic({
    required String doctorId,
  });
  Future<Either<Failure, BaseOneResponse>> getDoctorHome(String id);
  Future<Either<Failure, BaseListResponse>> getDoctorAppoinmentsForDay({
    required AppoinmentsParams params,
  });
  Future<Either<Failure, BaseOneResponse>> reschedule({
    required RescheduleParams params,
  });
}
