part of 'check_account_cubit.dart';

sealed class CheckAccountState extends Equatable {
  const CheckAccountState();

  @override
  List<Object?> get props => [];
}

final class CheckAccountInitial extends CheckAccountState {
  const CheckAccountInitial();
}

final class CheckAccountLoading extends CheckAccountState {
  const CheckAccountLoading();
}

final class CheckAccountSuccess extends CheckAccountState {
  final bool exists;
  final String message;

  const CheckAccountSuccess({
    required this.exists,
    required this.message,
  });

  @override
  List<Object?> get props => [exists, message];
}

final class CheckAccountFailure extends CheckAccountState {
  final String message;

  const CheckAccountFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
