import 'dart:io';

import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/features/delegate/data/models/medical_center_model.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/add_medical_center_params.dart';
import 'package:alhakim/injection_container.dart';
import 'package:dio/dio.dart';

abstract class MedicalCenterRemoteDataSource {
  Future<MedicalCentersRespModel> getMedicalCenters();
  Future<BaseOneResponse> addMedicalCenter({
    required AddMedicalCenterParams params,
  });
  Future<BaseOneResponse> updateMedicalCenter({
    required AddMedicalCenterParams params,
  });
  Future<BaseOneResponse> deleteMedicalCenter({
    required String medicalCenterId,
  });
  Future<BaseOneResponse> toggleMedicalCenterStatus({
    required String medicalCenterId,
  });
}

class MedicalCenterRemoteDataSourceImpl
    implements MedicalCenterRemoteDataSource {
  @override
  Future<MedicalCentersRespModel> getMedicalCenters() async {
    try {
      final response = await dioConsumer.get('/representative/medical-centers');

      if (response['status'] == true) {
        return MedicalCentersRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> addMedicalCenter({
    required AddMedicalCenterParams params,
  }) async {
    try {
      final formData = await _buildFormData(params);
      final response = await dioConsumer.post(
        '/representative/medical-centers',
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
  Future<BaseOneResponse> updateMedicalCenter({
    required AddMedicalCenterParams params,
  }) async {
    try {
      final formData = await _buildFormData(params, isUpdate: true);
      final response = await dioConsumer.post(
        '/representative/medical-centers/${params.id}',
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
  Future<BaseOneResponse> deleteMedicalCenter({
    required String medicalCenterId,
  }) async {
    try {
      final response = await dioConsumer.delete(
        '/representative/medical-centers/$medicalCenterId',
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
  Future<BaseOneResponse> toggleMedicalCenterStatus({
    required String medicalCenterId,
  }) async {
    try {
      final response = await dioConsumer.post(
        '/representative/medical-centers/$medicalCenterId/deactivate',
        formData: FormData.fromMap({"_method": "PATCH"}),
      );

      if (response['status'] == true) {
        return BaseOneResponse.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  Future<FormData> _buildFormData(
    AddMedicalCenterParams params, {
    bool isUpdate = false,
  }) async {
    final formData = FormData();

    if (isUpdate) {
      formData.fields.add(const MapEntry('_method', 'PUT'));
    }

    if (params.name != null) {
      formData.fields.add(MapEntry('name', params.name!));
    }
    if (params.description != null) {
      formData.fields.add(MapEntry('description', params.description!));
    }
    if (params.address != null) {
      formData.fields.add(MapEntry('address', params.address!));
    }
    if (params.countryCode != null) {
      formData.fields.add(MapEntry('country_code', params.countryCode!));
    }
    if (params.phone != null) {
      formData.fields.add(MapEntry('phone', params.phone!));
    }
    if (params.email != null) {
      formData.fields.add(MapEntry('email', params.email!));
    }

    await _appendFile(formData, 'logo', params.logo, compressImage: true);
    await _appendFile(formData, 'cover', params.cover, compressImage: true);
    await _appendFile(formData, 'license', params.license);

    return formData;
  }

  Future<void> _appendFile(
    FormData formData,
    String key,
    File? file, {
    bool compressImage = false,
  }) async {
    if (file == null) return;

    var uploadFile = file;

    if (compressImage || !Constants.checkPDFFiles(file.path)) {
      final compressed = await Constants.getCompressedFile(
        file,
        '${file.path}_compressed.jpg',
      );
      uploadFile = compressed ?? file;
    }

    formData.files.add(
      MapEntry(key, await MultipartFile.fromFile(uploadFile.path)),
    );
  }
}
