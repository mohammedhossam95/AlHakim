import 'package:alhakim/features/home/data/models/analyze_complaint_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class AnalyzeComplaintState extends Equatable {
  const AnalyzeComplaintState();

  @override
  List<Object?> get props => [];
}

class AnalyzeComplaintInitial extends AnalyzeComplaintState {}

class AnalyzeComplaintLoading extends AnalyzeComplaintState {}

class AnalyzeComplaintConsentRequired extends AnalyzeComplaintState {
  final DateTime blockedAt;

  AnalyzeComplaintConsentRequired() : blockedAt = DateTime.now();

  @override
  List<Object?> get props => [blockedAt];
}

class AnalyzeComplaintSuccess extends AnalyzeComplaintState {
  final AnalyzeComplaintResponse response;

  const AnalyzeComplaintSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class AnalyzeComplaintError extends AnalyzeComplaintState {
  final String message;

  const AnalyzeComplaintError(this.message);

  @override
  List<Object?> get props => [message];
}
