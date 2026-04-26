import 'package:alhakim/features/home/domain/entity/address_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressState(addresses: mockAddresses));

  static List<AddressEntity> mockAddresses = [
    AddressEntity(
      id: '1',
      label: 'المنزل', // Home
      fullAddress:
          'حي الملقا، شارع أنس بن مالك، الرياض، المملكة العربية السعودية',
      isDefault: true,
    ),
    AddressEntity(
      id: '2',
      label: 'المكتب', // Office
      fullAddress: 'برج المملكة، طريق الملك فهد، العليا، الرياض',
      isDefault: false,
    ),
    AddressEntity(
      id: '3',
      label: 'الاستراحة', // Common Saudi label for "Guesthouse/Rest house"
      fullAddress: 'حي الرمال، طريق الثمامة، الرياض',
      isDefault: false,
    ),
    AddressEntity(
      id: '4',
      label: 'الفرع الرئيسي', // Professional B2B label "Main Branch"
      fullAddress: 'طريق الملك عبدالعزيز، حي الشاطئ، جدة',
      isDefault: false,
    ),
  ];

  void selectAddress(String addressId) {
    final updatedList = state.addresses.map((address) {
      return address.copyWith(isDefault: address.id == addressId);
    }).toList();

    emit(AddressState(addresses: updatedList));
  }
}

class AddressState extends Equatable {
  final List<AddressEntity> addresses;
  const AddressState({required this.addresses});

  AddressEntity get activeAddress => addresses.firstWhere((e) => e.isDefault);

  @override
  List<Object> get props => [addresses];
}
