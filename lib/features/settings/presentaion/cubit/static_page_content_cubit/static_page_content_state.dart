part of 'static_page_content_cubit.dart';

abstract class StaticPageContentState extends Equatable {
  const StaticPageContentState();

  @override
  List<Object?> get props => [];
}

class StaticPageContentInitial extends StaticPageContentState {}

class StaticPageContentLoading extends StaticPageContentState {
  final bool isLoading;

  const StaticPageContentLoading({required this.isLoading});
}

class StaticPageContentLoaded extends StaticPageContentState {
  final BaseOneResponse resp;

  const StaticPageContentLoaded({required this.resp});

  @override
  List<Object?> get props => [resp];
}

class StaticPageContentError extends StaticPageContentState {
  final String message;

  const StaticPageContentError({required this.message});

  @override
  List<Object?> get props => [message];
}