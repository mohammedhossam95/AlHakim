part of 'notifications_count_cubit.dart';

sealed class NotificationsCountState extends Equatable {
  const NotificationsCountState();

  @override
  List<Object> get props => [];
}

final class NotificationsCountInitial extends NotificationsCountState {}

final class NotificationsCountLoadingState extends NotificationsCountState {
  final bool isLoading;

  const NotificationsCountLoadingState({required this.isLoading});
}

final class NotificationsCountSuccessState extends NotificationsCountState {
  final BaseOneResponse response;
  const NotificationsCountSuccessState({required this.response});
}

final class NotificationsCountFailureState extends NotificationsCountState {
  final String errorMessage;

  const NotificationsCountFailureState({required this.errorMessage});
}
