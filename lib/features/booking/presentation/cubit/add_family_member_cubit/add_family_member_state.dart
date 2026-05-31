part of 'add_family_member_cubit.dart';

sealed class AddFamilyMemberState extends Equatable {
  const AddFamilyMemberState();

  @override
  List<Object?> get props => [];
}

final class AddFamilyMemberInitial extends AddFamilyMemberState {}

final class AddFamilyMemberLoading extends AddFamilyMemberState {}

final class AddFamilyMemberSuccess extends AddFamilyMemberState {
  final BaseOneResponse response;

  const AddFamilyMemberSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class AddFamilyMemberError extends AddFamilyMemberState {
  final String message;

  const AddFamilyMemberError({required this.message});

  @override
  List<Object?> get props => [message];
}
