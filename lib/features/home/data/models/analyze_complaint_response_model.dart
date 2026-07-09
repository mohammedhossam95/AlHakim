import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/data/models/doctor_model.dart';

class AnalyzeComplaintResponse extends BaseOneResponse {
  const AnalyzeComplaintResponse({super.status, super.message, super.data});

  factory AnalyzeComplaintResponse.fromJson(Map<String, dynamic> json) {
    return AnalyzeComplaintResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? AnalyzeComplaintData.fromJson(json['data'])
          : null,
    );
  }

  AnalyzeComplaintData? get complaintData =>
      data is AnalyzeComplaintData ? data as AnalyzeComplaintData : null;
}

class AnalyzeComplaintData {
  final String analysis;
  final String suggestion;
  final List<DoctorModel> doctors;

  const AnalyzeComplaintData({
    required this.analysis,
    required this.suggestion,
    required this.doctors,
  });

  factory AnalyzeComplaintData.fromJson(Map<String, dynamic> json) {
    return AnalyzeComplaintData(
      analysis: json['analysis'] ?? '',
      suggestion: json['suggestion'] ?? '',
      doctors: json['doctors'] != null
          ? (json['doctors'] as List)
                .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}
