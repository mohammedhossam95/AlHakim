import 'package:equatable/equatable.dart';

abstract class AiConsentState extends Equatable {
  const AiConsentState();

  @override
  List<Object?> get props => [];
}

class AiConsentInitial extends AiConsentState {}

class AiConsentLoading extends AiConsentState {}

class AiConsentGranted extends AiConsentState {}

class AiConsentNotGranted extends AiConsentState {}

class AiConsentError extends AiConsentState {
  final String message;

  const AiConsentError(this.message);

  @override
  List<Object?> get props => [message];
}
