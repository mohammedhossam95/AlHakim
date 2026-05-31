import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:alhakim/features/booking/domain/repositories/booking_repository.dart';
import 'package:dartz/dartz.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BaseListResponse>> getKinships() async {
    try {
      final result = await remoteDataSource.getKinships();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseListResponse>> getFamilyMembers() async {
    try {
      final result = await remoteDataSource.getFamilyMembers();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> addFamilyMember({
    required String fullName,
    required String birthDate,
    required String kinship,
  }) async {
    try {
      final result = await remoteDataSource.addFamilyMember(
        fullName: fullName,
        birthDate: birthDate,
        kinship: kinship,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> bookAppointment({
    required String doctorId,
    required String appointmentDate,
    String? familyMemberId,
  }) async {
    try {
      final result = await remoteDataSource.bookAppointment(
        doctorId: doctorId,
        appointmentDate: appointmentDate,
        familyMemberId: familyMemberId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
