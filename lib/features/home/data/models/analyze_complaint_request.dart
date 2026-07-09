import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class AnalyzeComplaintRequest extends Equatable {
  final String complaint;

  const AnalyzeComplaintRequest({required this.complaint});

  Map<String, dynamic> toJson() => {'complaint': complaint};

  FormData toFormData() => FormData.fromMap(toJson());

  @override
  List<Object?> get props => [complaint];
}
