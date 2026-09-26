import 'package:equatable/equatable.dart';

class AiConsent extends Equatable {
  final bool accepted;
  final DateTime? acceptedAt;

  const AiConsent({required this.accepted, this.acceptedAt});

  @override
  List<Object?> get props => [accepted, acceptedAt];
}
