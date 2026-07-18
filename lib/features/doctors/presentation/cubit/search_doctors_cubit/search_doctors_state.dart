part of 'search_doctors_cubit.dart';

sealed class SearchDoctorsState extends Equatable {
  const SearchDoctorsState();

  @override
  List<Object?> get props => [];
}

final class SearchDoctorsInitial extends SearchDoctorsState {}

final class SearchDoctorsLoading extends SearchDoctorsState {
  final List<DoctorEntity> previousDoctors;

  const SearchDoctorsLoading({this.previousDoctors = const []});

  @override
  List<Object?> get props => [previousDoctors];
}

final class SearchDoctorsLoaded extends SearchDoctorsState {
  final List<DoctorEntity> doctors;

  const SearchDoctorsLoaded({required this.doctors});

  @override
  List<Object?> get props => [doctors];
}

final class SearchDoctorsEmpty extends SearchDoctorsState {
  const SearchDoctorsEmpty();
}

final class SearchDoctorsError extends SearchDoctorsState {
  final String message;

  const SearchDoctorsError({required this.message});

  @override
  List<Object?> get props => [message];
}
