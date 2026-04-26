import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/auth/domain/entities/cities_entity.dart';

class CitiesRespModel extends BaseListResponse {
  const CitiesRespModel({super.success, super.message, super.data});

  factory CitiesRespModel.fromJson(Map<String, dynamic> json) =>
      CitiesRespModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<CitiesModel>.from(
                json["data"].map((x) => CitiesModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    'message': message,
    'data': data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CitiesModel extends CitiesEntity {
  const CitiesModel({super.id, super.name});

  factory CitiesModel.fromJson(Map<String, dynamic> json) {
    return CitiesModel(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
