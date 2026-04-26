import 'package:alhakim/core/base_classes/pagination.dart';
import 'package:alhakim/features/home/domain/entity/ads_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AllAdsState extends Equatable {
  const AllAdsState();

  @override
  List<Object?> get props => [];
}

class AllAdsInitial extends AllAdsState {}

class AllAdsLoading extends AllAdsState {}

class AllAdsPaginationLoading extends AllAdsState {
  final List<AdEntity> oldAds;

  const AllAdsPaginationLoading(this.oldAds);

  @override
  List<Object?> get props => [oldAds];
}

class AllAdsSuccess extends AllAdsState {
  final List<AdEntity> ads;
  final Pagination? pagination;

  const AllAdsSuccess({required this.ads, this.pagination});

  @override
  List<Object?> get props => [ads, pagination];
}

class AllAdsError extends AllAdsState {
  final String message;

  const AllAdsError(this.message);

  @override
  List<Object?> get props => [message];
}
