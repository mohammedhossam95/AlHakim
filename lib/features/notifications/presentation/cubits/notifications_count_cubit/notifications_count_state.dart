part of 'notifications_count_cubit.dart';

sealed class NotificationsCountState extends Equatable {
  const NotificationsCountState();

  @override
  List<Object?> get props => [];
}

final class NotificationsCountInitial extends NotificationsCountState {
  const NotificationsCountInitial();
}

final class NotificationsCountLoadingState extends NotificationsCountState {
  const NotificationsCountLoadingState();
}

final class NotificationsCountSuccessState extends NotificationsCountState {
  final int unreadCount;

  const NotificationsCountSuccessState({required this.unreadCount});

  @override
  List<Object?> get props => [unreadCount];
}

final class NotificationsCountFailureState extends NotificationsCountState {
  final String errorMessage;

  const NotificationsCountFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
