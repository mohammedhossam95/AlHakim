part of 'get_emergency_categories_cubit.dart';

sealed class GetEmergencyCategoriesState extends Equatable {
  const GetEmergencyCategoriesState();

  @override
  List<Object?> get props => [];
}

final class GetEmergencyCategoriesInitial extends GetEmergencyCategoriesState {}

final class GetEmergencyCategoriesLoading extends GetEmergencyCategoriesState {}

final class GetEmergencyCategoriesSuccess extends GetEmergencyCategoriesState {
  final BaseListResponse response;

  const GetEmergencyCategoriesSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetEmergencyCategoriesError extends GetEmergencyCategoriesState {
  final String message;

  const GetEmergencyCategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}
