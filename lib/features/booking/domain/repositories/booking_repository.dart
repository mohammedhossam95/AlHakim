import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/booking/domain/usecases/params/booking_params.dart';
import 'package:alhakim/features/booking/domain/usecases/params/delete_family_member_params.dart';
import 'package:alhakim/features/booking/domain/usecases/params/update_family_member_params.dart';
import 'package:dartz/dartz.dart';

abstract class BookingRepository {
  Future<Either<Failure, BaseListResponse>> getKinships();
  Future<Either<Failure, BaseListResponse>> getFamilyMembers();
  Future<Either<Failure, BaseListResponse>> getAppointmentTypes();

  Future<Either<Failure, BaseOneResponse>> addFamilyMember({
    required String fullName,
    required String birthDate,
    required String kinship,
  });
  Future<Either<Failure, BaseOneResponse>> updateFamilyMember({
    required UpdateFamilyMemberParams params,
  });
  Future<Either<Failure, BaseOneResponse>> deleteFamilyMember({
    required DeleteFamilyMemberParams params,
  });
  Future<Either<Failure, BaseOneResponse>> bookAppointment(BookingParams params);
}
