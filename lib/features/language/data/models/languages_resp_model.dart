import '/core/base_classes/base_list_response.dart';
import '/features/language/domain/entities/languages_response.dart';

class LanguagesRespModel extends BaseListResponse {
  const LanguagesRespModel({
    super.success,
    super.message,
    List<LanguageModel>? super.data,
  });

  factory LanguagesRespModel.fromJson(Map<String, dynamic> json) =>
      LanguagesRespModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : List<LanguageModel>.from(
                json['data']!.map((x) => LanguageModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LanguageModel extends Language {
  const LanguageModel({
    super.id,
    super.name,
    super.code,
    super.active,
    super.datumDefault,
    super.direction,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        active: json['active'],
        datumDefault: json['default'],
        direction: json['direction']!,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'active': active,
        'default': datumDefault,
        'direction': direction,
      };
}
