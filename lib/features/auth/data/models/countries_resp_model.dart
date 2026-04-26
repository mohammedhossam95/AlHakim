import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/auth/domain/entities/countries_entity.dart';

class CountriesRespModel extends BaseListResponse {
  const CountriesRespModel({super.status, super.message, super.data});

  factory CountriesRespModel.fromJson(Map<String, dynamic> json) =>
      CountriesRespModel(
        status: json["status"],
        message: json["message"],
        data: json["result"] == null
            ? []
            : List<CountryModel>.from(
                json["result"].map((x) => CountryModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CountryModel extends CountriesEntity {
  const CountryModel({
    super.id,
    super.nameAr,
    super.createdAt,
    super.updatedAt,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      nameAr: json['name_ar'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
