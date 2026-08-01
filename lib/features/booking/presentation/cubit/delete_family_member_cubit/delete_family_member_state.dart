part of 'delete_family_member_cubit.dart';

sealed class DeleteFamilyMemberState extends Equatable {
  const DeleteFamilyMemberState();

  @override
  List<Object?> get props => [];
}

final class DeleteFamilyMemberInitial extends DeleteFamilyMemberState {}

final class DeleteFamilyMemberLoading extends DeleteFamilyMemberState {}

final class DeleteFamilyMemberSuccess extends DeleteFamilyMemberState {
  final BaseOneResponse response;

  const DeleteFamilyMemberSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class DeleteFamilyMemberError extends DeleteFamilyMemberState {
  final String message;

  const DeleteFamilyMemberError({required this.message});

  @override
  List<Object?> get props => [message];
}
