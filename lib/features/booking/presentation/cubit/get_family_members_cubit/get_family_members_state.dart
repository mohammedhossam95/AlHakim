part of 'get_family_members_cubit.dart';

sealed class GetFamilyMembersState extends Equatable {
  const GetFamilyMembersState();

  @override
  List<Object?> get props => [];
}

final class GetFamilyMembersInitial extends GetFamilyMembersState {}

final class GetFamilyMembersLoading extends GetFamilyMembersState {}

final class GetFamilyMembersSuccess extends GetFamilyMembersState {
  final BaseListResponse response;

  const GetFamilyMembersSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetFamilyMembersError extends GetFamilyMembersState {
  final String message;

  const GetFamilyMembersError({required this.message});

  @override
  List<Object?> get props => [message];
}
