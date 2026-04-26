import 'package:equatable/equatable.dart';

class ContactUsParam extends Equatable {
  final String? name;
  final String? email;
  final String? phone;
  final String? message;
  const ContactUsParam({
    this.name,
    this.email,
    this.phone,
    this.message
  });
  Map<String,dynamic>toJson(){
    return{
      'name':name,
      'email':email,
      'phone':phone,
      'message':message
    };
  }
  @override
  List<Object?> get props => [];
}
