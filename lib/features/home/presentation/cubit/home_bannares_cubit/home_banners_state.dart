import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:equatable/equatable.dart';

abstract class HomeBannaresState extends Equatable {
  const HomeBannaresState();

  @override
  List<Object?> get props => [];
}

class HomeBannaresInitialState extends HomeBannaresState {}

class HomeBannaresLoadingState extends HomeBannaresState {}

class HomeBannaresSuccessState extends HomeBannaresState {
  final BaseListResponse response;

  const HomeBannaresSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class HomeBannaresErrorState extends HomeBannaresState {
  final String message;

  const HomeBannaresErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
