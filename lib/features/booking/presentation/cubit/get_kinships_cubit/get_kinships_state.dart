part of 'get_kinships_cubit.dart';

sealed class GetKinshipsState extends Equatable {
  const GetKinshipsState();

  @override
  List<Object?> get props => [];
}

final class GetKinshipsInitial extends GetKinshipsState {}

final class GetKinshipsLoading extends GetKinshipsState {}

final class GetKinshipsSuccess extends GetKinshipsState {
  final BaseListResponse response;

  const GetKinshipsSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetKinshipsError extends GetKinshipsState {
  final String message;

  const GetKinshipsError({required this.message});

  @override
  List<Object?> get props => [message];
}
