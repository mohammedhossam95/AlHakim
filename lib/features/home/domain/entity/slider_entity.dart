import 'package:equatable/equatable.dart';

class SliderEntity extends Equatable {
  final int? id;
  final String? image;
  final String? link;
  final String? redirectType;
  final String? redirectTypeId;

  const SliderEntity({
    this.id,
    this.image,
    this.link,
    this.redirectType,
    this.redirectTypeId,
  });

  @override
  List<Object?> get props => [id, image, link, redirectType, redirectTypeId];
}
