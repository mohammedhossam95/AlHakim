part of 'app_setting_cubit.dart';

abstract class AppSettingState extends Equatable {
  const AppSettingState();

  @override
  List<Object> get props => [];
}

class AppSettingInitial extends AppSettingState {}
class AppSettingLoading extends AppSettingState {
  final bool isLoading;

  const AppSettingLoading({required this.isLoading});
}

class AppSettingLoaded extends AppSettingState {
  final BaseListResponse resp;

  const AppSettingLoaded({required this.resp});

  @override
  List<Object> get props => [resp];
}

class AppSettingError extends AppSettingState {
  final String message;

  const AppSettingError({required this.message});

  @override
  List<Object> get props => [message];
}

