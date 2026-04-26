part of 'get_setting_cubit.dart';

abstract class GetSettingState extends Equatable {
  const GetSettingState();

  @override
  List<Object> get props => [];
}

class GetSettingInitial extends GetSettingState {}

class GetSettingLoading extends GetSettingState {
  final bool isLoading;
  const GetSettingLoading({required this.isLoading});
}

class GetSettingLoaded extends GetSettingState {
  final BaseOneResponse resp;
  const GetSettingLoaded({required this.resp});
}

class GetSettingError extends GetSettingState {
  final String errorMessage;
  const GetSettingError({required this.errorMessage});
}
