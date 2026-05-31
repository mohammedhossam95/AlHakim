import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/features/doctors/data/models/doctor_model.dart';
import 'package:alhakim/features/specialities/data/models/specialty_model.dart';
import 'package:alhakim/injection_container.dart';

abstract class SpecialtyRemoteDataSource {
  Future<SpecialtiesRespModel> getSpecialties();
  Future<DoctorsRespModel> getSpecialtyDoctors(String id);
}

class SpecialtyRemoteDataSourceImpl implements SpecialtyRemoteDataSource {
  @override
  Future<SpecialtiesRespModel> getSpecialties() async {
    try {
      final response = await dioConsumer.get('/specialties');

      if (response['status'] == true) {
        return SpecialtiesRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DoctorsRespModel> getSpecialtyDoctors(String id) async {
    try {
      final response = await dioConsumer.get('/specialties/$id/doctors');

      if (response['status'] == true) {
        return DoctorsRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }
}
