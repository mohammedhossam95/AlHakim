part of 'get_specialties_cubit.dart';

sealed class GetSpecialtiesState
    extends Equatable {
  const GetSpecialtiesState();

  @override
  List<Object> get props => [];
}

final class GetSpecialtiesInitial
    extends GetSpecialtiesState {}

final class GetSpecialtiesLoading
    extends GetSpecialtiesState {}

final class GetSpecialtiesSuccess
    extends GetSpecialtiesState {
  final BaseListResponse response;

  const GetSpecialtiesSuccess({
    required this.response,
  });
}

final class GetSpecialtiesError
    extends GetSpecialtiesState {
  final String message;

  const GetSpecialtiesError({
    required this.message,
  });
}