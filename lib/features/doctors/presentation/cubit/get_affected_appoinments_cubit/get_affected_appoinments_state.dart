part of 'get_affected_appoinments_cubit.dart';

sealed class GetAffectedAppoinmentsState extends Equatable {
  const GetAffectedAppoinmentsState();

  @override
  List<Object?> get props => [];
}

final class GetAffectedAppoinmentsInitial
    extends GetAffectedAppoinmentsState {}

final class GetAffectedAppoinmentsLoading
    extends GetAffectedAppoinmentsState {}

final class GetAffectedAppoinmentsSuccess
    extends GetAffectedAppoinmentsState {
  final BaseListResponse response;

  const GetAffectedAppoinmentsSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetAffectedAppoinmentsError
    extends GetAffectedAppoinmentsState {
  final String message;

  const GetAffectedAppoinmentsError({required this.message});

  @override
  List<Object?> get props => [message];
}
