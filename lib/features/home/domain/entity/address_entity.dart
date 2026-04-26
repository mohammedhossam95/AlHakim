import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String label;
  final String fullAddress;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.isDefault = false,
  });

  // Equatable requires overriding this getter
  @override
  List<Object?> get props => [id, label, fullAddress, isDefault];

  // Useful for creating a new instance with updated values (e.g., changing isDefault)
  AddressEntity copyWith({
    String? id,
    String? label,
    String? fullAddress,
    bool? isDefault,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}