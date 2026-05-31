import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class BookingRepository {
  Future<Either<Failure, BaseListResponse>> getKinships();
  Future<Either<Failure, BaseListResponse>> getFamilyMembers();

  Future<Either<Failure, BaseOneResponse>> addFamilyMember({
    required String fullName,
    required String birthDate,
    required String kinship,
  });
  Future<Either<Failure, BaseOneResponse>> bookAppointment({
    required String doctorId,
    required String appointmentDate,
    String? familyMemberId,
  });
}
