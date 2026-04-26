import 'package:equatable/equatable.dart';

class StaticPageEntity extends Equatable {
  final int? id;
  final String? key;
  final String? value;

  const StaticPageEntity({
    this.id,
    this.key,
    this.value,
  });

  @override
  List<Object?> get props => [id, key, value];
}