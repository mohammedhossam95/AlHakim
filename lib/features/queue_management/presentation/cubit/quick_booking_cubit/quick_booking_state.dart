part of 'quick_booking_cubit.dart';

sealed class QuickBookingState extends Equatable {
  const QuickBookingState();

  @override
  List<Object?> get props => [];
}

final class QuickBookingInitial extends QuickBookingState {}

final class QuickBookingLoading extends QuickBookingState {}

final class QuickBookingSuccess extends QuickBookingState {
  final BaseOneResponse response;

  const QuickBookingSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class QuickBookingError extends QuickBookingState {
  final String message;

  const QuickBookingError({required this.message});

  @override
  List<Object?> get props => [message];
}
