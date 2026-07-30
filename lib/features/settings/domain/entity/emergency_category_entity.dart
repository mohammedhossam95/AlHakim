import 'package:equatable/equatable.dart';

class EmergencyCategoryEntity extends Equatable {
  final int? id;
  final String? name;
  final String? image;
  final bool? isActive;

  const EmergencyCategoryEntity({
    this.id,
    this.name,
    this.image,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, image, isActive];
}
