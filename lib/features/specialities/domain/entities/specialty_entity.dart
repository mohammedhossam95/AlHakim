import 'package:equatable/equatable.dart';

class SpecialtyEntity extends Equatable {
  final int? id;
  final String? icon;
  final SpecialtyEntity? mainSpecialty;
  final String? isActive;
  final String? sortOrder;
  final String? name;
  final String? slug;
  final bool? hasChildren;
  final int? doctorsCount;
  final String? createdAt;
  final String? updatedAt;

  const SpecialtyEntity({
    this.id,
    this.icon,
    this.mainSpecialty,
    this.isActive,
    this.sortOrder,
    this.name,
    this.slug,
    this.hasChildren,
    this.doctorsCount,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        icon,
        mainSpecialty,
        isActive,
        sortOrder,
        name,
        slug,
        hasChildren,
        doctorsCount,
        createdAt,
        updatedAt,
      ];
}