import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final bool? active;
  final bool? datumDefault;
  final String? direction;

  const Language({
    this.id,
    this.name,
    this.code,
    this.active,
    this.datumDefault,
    this.direction,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        active,
        datumDefault,
        direction,
      ];
}
