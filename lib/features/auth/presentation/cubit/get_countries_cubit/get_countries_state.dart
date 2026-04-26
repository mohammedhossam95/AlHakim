part of 'get_countries_cubit.dart';

abstract class GetCountriesState extends Equatable {
  const GetCountriesState();
  @override
  List<Object> get props => [];
}

class GetCountriesInitial extends GetCountriesState {}

class GetCountriesIsLoading extends GetCountriesState {}

class GetCountriesLoaded extends GetCountriesState {
  final BaseListResponse response;

  const GetCountriesLoaded({required this.response});
}

class GetCountriesError extends GetCountriesState {
  final String message;
  const GetCountriesError(this.message);
}

