import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/features/doctors/data/models/doctor_model.dart';
import 'package:alhakim/features/specialities/data/models/specialty_model.dart';
import 'package:alhakim/features/specialities/domain/usecases/params/get_specialty_doctors_params.dart';
import 'package:alhakim/injection_container.dart';

abstract class SpecialtyRemoteDataSource {
  Future<SpecialtiesRespModel> getSpecialties();
  Future<DoctorsRespModel> getSpecialtyDoctors(
    GetSpecialtyDoctorsParams params,
  );
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
  Future<DoctorsRespModel> getSpecialtyDoctors(
    GetSpecialtyDoctorsParams params,
  ) async {
    try {
      final response = await dioConsumer.get(
        '/specialties/${params.specialtyId}/doctors',
        queryParameters: {
          'per_page': params.perPage,
          if (params.search != null && params.search!.isNotEmpty)
            'search': params.search,
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
}
