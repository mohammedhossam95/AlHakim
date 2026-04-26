part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoadingState extends NotificationsState {
  final bool isLoading;

  const NotificationsLoadingState({required this.isLoading});
}

final class NotificationsSuccessState extends NotificationsState {
  final BaseOneResponse response;

  const NotificationsSuccessState({required this.response});
}

final class NotificationsFailureState extends NotificationsState {
  final String errorMessage;

  const NotificationsFailureState({required this.errorMessage});
}
