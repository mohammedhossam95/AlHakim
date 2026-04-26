import 'dart:convert';

import 'package:equatable/equatable.dart';

class AddressParams extends Equatable {
  final int? id;
  final String? method;
  final String? cityId;
  final String? area;
  final String? buildingNo;
  final String? floor;
  final String? apartment;
  final String? name;
  final String? notes;
  final String? latitude;
  final String? longitude;
  final String? addressDetails;
  final int? isDefault;

  const AddressParams({
    this.id,
    this.method,
    this.cityId,
    this.area,
    this.buildingNo,
    this.floor,
    this.apartment,
    this.name,
    this.notes,
    this.latitude,
    this.longitude,
    this.addressDetails,
    this.isDefault,
  });

  @override
  List<Object?> get props => [
    id,
    method,
    cityId,
    area,
    buildingNo,
    floor,
    apartment,
    name,
    notes,
    latitude,
    longitude,
    addressDetails,
    isDefault,
  ];

  /// 🔹 Convert object → Map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "method": method,
      "city_id": cityId,
      "area": area,
      "building_no": buildingNo,
      "floor": floor,
      "apartment": apartment,
      "name": name,
      "notes": notes,
      "latitude": latitude,
      "longitude": longitude,
      "address_details": addressDetails,
      "default": isDefault,
    };
  }

  /// 🔹 Convert Map → object
  factory AddressParams.fromMap(Map<String, dynamic> map) {
    return AddressParams(
      id: map["id"],
      method: map["method"],
      cityId: map["city_id"],
      area: map["area"],
      buildingNo: map["building_no"],
      floor: map["floor"],
      apartment: map["apartment"],
      name: map["name"],
      notes: map["notes"],
      latitude: map["latitude"]?.toString(),
      longitude: map["longitude"]?.toString(),
      addressDetails: map["address_details"],
      isDefault: map["default"],
    );
  }

  /// 🔹 Object → JSON
  String toJson() => jsonEncode(toMap());

  /// 🔹 JSON → Object
  factory AddressParams.fromJson(String source) =>
      AddressParams.fromMap(jsonDecode(source));
}
