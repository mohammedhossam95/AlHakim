import 'package:equatable/equatable.dart';

class FamilyMemberEntity extends Equatable {
  final String? id;
  final String? fullName;
  final String? birthDate;
  final KinshipDataEntity? kinship;

  const FamilyMemberEntity({
    this.id,
    this.fullName,
    this.birthDate,
    this.kinship,
  });

  @override
  List<Object?> get props => [id, fullName, birthDate, kinship];
}

class KinshipDataEntity extends Equatable {
  final String? value;
  final String? label;

  const KinshipDataEntity({this.value, this.label});

  @override
  List<Object?> get props => [value, label];
}
