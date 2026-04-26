part of 'contact_us_cubit.dart';

abstract class ContactUsState extends Equatable {
  const ContactUsState();

  @override
  List<Object> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}
class ContactUsSuccess extends ContactUsState {
  final BaseOneResponse resp;
  const ContactUsSuccess(this.resp);
  @override
  List<Object> get props => [resp];
}
class ContactUsError extends ContactUsState {
  final String errorMessage;

  const ContactUsError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
