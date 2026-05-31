part of 'get_representative_stats_cubit.dart';

sealed class GetRepresentativeStatsState extends Equatable {
  const GetRepresentativeStatsState();

  @override
  List<Object?> get props => [];
}

final class GetRepresentativeStatsInitial extends GetRepresentativeStatsState {}

final class GetRepresentativeStatsLoading extends GetRepresentativeStatsState {}

final class GetRepresentativeStatsSuccess extends GetRepresentativeStatsState {
  final BaseOneResponse response;

  const GetRepresentativeStatsSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetRepresentativeStatsError extends GetRepresentativeStatsState {
  final String message;

  const GetRepresentativeStatsError({required this.message});

  @override
  List<Object?> get props => [message];
}
