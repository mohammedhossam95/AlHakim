import 'package:alhakim/core/base_classes/pagination.dart';
import 'package:alhakim/features/home/domain/entity/ads_entity.dart';
import 'package:alhakim/features/home/domain/use_case/get_ads_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'all_ads_state.dart';

class AllAdsCubit extends Cubit<AllAdsState> {
  final GetListAdsUsecase usecase;

  AllAdsCubit({required this.usecase}) : super(AllAdsInitial());

  List<AdEntity> ads = [];
  Pagination? pagination;
  bool isLoading = false;

  String currentSearch = '';

  Future<void> getAds({
    bool isPagination = false,
    String? search,
    int? adId,
  }) async {
    if (isLoading) return;

    /// 🔎 If search changed → reset everything
    if (search != null && search != currentSearch) {
      currentSearch = search;
      pagination = null;
      ads.clear();
      isPagination = false;
    }

    final currentPage = isPagination ? (pagination?.currentPage ?? 1) + 1 : 1;

    if (!isPagination) {
      emit(AllAdsLoading());
    } else {
      emit(AllAdsPaginationLoading(ads));
    }

    isLoading = true;

    final result = await usecase.call(
      AdsParams(currentPage: currentPage, search: currentSearch, id: adId),
    );

    result.fold(
      (failure) {
        emit(AllAdsError(failure.message ?? ''));
      },
      (response) {
        final newAds = response.data as List<AdEntity>? ?? [];

        if (isPagination) {
          ads.addAll(newAds);
        } else {
          ads = newAds;
        }

        pagination = response.pagination;

        emit(AllAdsSuccess(ads: ads, pagination: pagination));
      },
    );

    isLoading = false;
  }

  bool get hasMore => pagination?.hasMore ?? false;

  /// Optional helper
  void reset() {
    ads.clear();
    pagination = null;
    currentSearch = '';
  }
}
