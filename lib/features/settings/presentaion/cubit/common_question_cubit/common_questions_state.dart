part of 'common_questions_cubit.dart';

abstract class CommonQuestionsState extends Equatable {
  const CommonQuestionsState();

  @override
  List<Object> get props => [];
}

class CommonQuestionsInitial extends CommonQuestionsState {}

class CommonQuestionsLoading extends CommonQuestionsState {
  final bool isLoading;
  const CommonQuestionsLoading({required this.isLoading});
}

class CommonQuestionsLoaded extends CommonQuestionsState {
  final BaseListResponse resp;

  const CommonQuestionsLoaded(this.resp);
}

class CommonQuestionsError extends CommonQuestionsState {
  final String errorMessage;

  const CommonQuestionsError(this.errorMessage);
}
