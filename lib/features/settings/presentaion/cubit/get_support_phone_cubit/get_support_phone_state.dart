part of 'get_support_phone_cubit.dart';

abstract class SupportPhoneState extends Equatable {
  const SupportPhoneState();

  @override
  List<Object> get props => [];
}

class SupportPhoneInitialState extends SupportPhoneState {}

class SupportPhoneLoadingState extends SupportPhoneState {
  final bool isLoading;

  const SupportPhoneLoadingState({required this.isLoading});
}

class SupportPhoneSuccessState extends SupportPhoneState {
  final SupportPhoneResp resp;
  const SupportPhoneSuccessState(this.resp);
  @override
  List<Object> get props => [resp];
}

class SupportPhoneErrorState extends SupportPhoneState {
  final String errorMessage;

  const SupportPhoneErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
