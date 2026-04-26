import 'package:alhakim/core/base_classes/base_one_response.dart';

class SendCodeRespModel extends BaseOneResponse {
  const SendCodeRespModel({super.success, super.data, super.message});

  factory SendCodeRespModel.fromJson(Map<String, dynamic> json) =>
      SendCodeRespModel(
        data: json["data"] == null
            ? null
            : SendCodeModel.fromJson(json["data"]),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "success": success,
    "message": message,
  };
}

class SendCodeModel {
  final bool? done;
  final int? code;

  const SendCodeModel({this.done, this.code});

  factory SendCodeModel.fromJson(Map<String, dynamic> json) {
    return SendCodeModel(done: json['done'], code: json['code']);
  }

  Map<String, dynamic> toJson() {
    return {'done': done, 'code': code};
  }
}
