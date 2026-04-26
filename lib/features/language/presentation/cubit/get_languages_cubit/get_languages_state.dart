part of 'get_languages_cubit.dart';

abstract class GetLanguagesState extends Equatable {
  const GetLanguagesState();

  @override
  List<Object> get props => [];
}

class GetLanguagesInitial extends GetLanguagesState {}

class GetLanguagesIsLoading extends GetLanguagesState {
  final bool isLoading;
  const GetLanguagesIsLoading(this.isLoading);
}

class GetLanguagesLoaded extends GetLanguagesState {
  final BaseListResponse response;
  const GetLanguagesLoaded({required this.response});
}

class GetLanguagesError extends GetLanguagesState {
  final String msg;
  const GetLanguagesError({required this.msg});
}
