import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:equatable/equatable.dart';

class CheckAccountRespModel extends BaseOneResponse {
  const CheckAccountRespModel({super.status, super.message, super.data});

  factory CheckAccountRespModel.fromJson(Map<String, dynamic> json) {
    return CheckAccountRespModel(
      status: json['status'],
      message: json['message']?.toString(),
      data: json['data'] != null
          ? CheckAccountData.fromJson(
              json['data'] as Map<String, dynamic>? ?? const {},
            )
          : null,
    );
  }
}

class CheckAccountData extends Equatable {
  final bool exists;

  const CheckAccountData({required this.exists});

  factory CheckAccountData.fromJson(Map<String, dynamic> json) {
    return CheckAccountData(
      exists: json['exists'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [exists];
}
