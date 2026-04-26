import 'package:equatable/equatable.dart';

class SupportPhoneResp extends Equatable {
  final String? key;
  final String? value;

  const SupportPhoneResp({
    this.key,
    this.value,
  });

  @override
  List<Object?> get props => [
        key,
        value,
      ];
}
