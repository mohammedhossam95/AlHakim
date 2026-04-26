part of 'get_all_cities_cubit.dart';

abstract class GetAllCitiesState extends Equatable {
  const GetAllCitiesState();
  @override
  List<Object> get props => [];
}

class GetAllCitiesInitial extends GetAllCitiesState {}

class GetAllCitiesIsLoading extends GetAllCitiesState {}

class GetAllCitiesLoaded extends GetAllCitiesState {
  final BaseListResponse response;

  const GetAllCitiesLoaded({required this.response});
}

class GetAllCitiesError extends GetAllCitiesState {
  final String message;
  const GetAllCitiesError(this.message);
}
