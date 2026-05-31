import 'package:equatable/equatable.dart';

class KinshipEntity extends Equatable {
  final String? value;
  final String? label;

  const KinshipEntity({
    this.value,
    this.label,
  });

  @override
  List<Object?> get props => [
        value,
        label,
      ];
}