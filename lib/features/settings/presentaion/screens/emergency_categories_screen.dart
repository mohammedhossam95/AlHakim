import 'dart:async';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/shimmer/emergency_categories_shimmer.dart';
import 'package:alhakim/features/settings/domain/entity/emergency_category_entity.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_emergency_categories_cubit/get_emergency_categories_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/features/settings/presentaion/widgets/emergency_category_card.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmergencyCategoriesScreen extends StatefulWidget {
  final bool isInTabBar;

  const EmergencyCategoriesScreen({super.key, this.isInTabBar = true});

  @override
  State<EmergencyCategoriesScreen> createState() =>
      _EmergencyCategoriesScreenState();
}

class _EmergencyCategoriesScreenState extends State<EmergencyCategoriesScreen> {
  Completer<void>? _refreshCompleter;
  StreamSubscription<GetEmergencyCategoriesState>? _refreshSubscription;

  @override
  void initState() {
    super.initState();
    context.read<GetEmergencyCategoriesCubit>().getEmergencyCategories();
  }

  @override
  void dispose() {
    _refreshSubscription?.cancel();
    super.dispose();
  }

  List<EmergencyCategoryEntity> _activeCategories(
    GetEmergencyCategoriesState state,
  ) {
    if (state is! GetEmergencyCategoriesSuccess) return [];

    return (state.response.data ?? [])
        .whereType<EmergencyCategoryEntity>()
        .where((e) => e.isActive != false)
        .toList();
  }

  Future<void> _onRefresh() {
    _refreshSubscription?.cancel();
    _refreshCompleter = Completer<void>();

    _refreshSubscription = context
        .read<GetEmergencyCategoriesCubit>()
        .stream
        .listen((state) {
          if (state is GetEmergencyCategoriesSuccess ||
              state is GetEmergencyCategoriesError) {
            if (!(_refreshCompleter?.isCompleted ?? true)) {
              _refreshCompleter?.complete();
            }
            _refreshSubscription?.cancel();
            _refreshSubscription = null;
          }
        });

    context.read<GetEmergencyCategoriesCubit>().getEmergencyCategories();
    return _refreshCompleter!.future;
  }

  void _openCategory(EmergencyCategoryEntity category) {
    context.push(
      Routes.emergencyScreenRoute,
      extra: {'categoryId': category.id, 'categoryName': category.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtil().screenWidth;

    return Scaffold(
      backgroundColor: colors.main,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: CustomAppBar(
                title: 'emergency'.tr,
                isInTabBar: widget.isInTabBar,
                titleColor: colors.whiteColor,
              ),
            ),
            Divider(),
            Gaps.vGap20,
            Expanded(
              child:
                  BlocBuilder<
                    GetEmergencyCategoriesCubit,
                    GetEmergencyCategoriesState
                  >(
                    builder: (context, state) {
                      if (state is GetEmergencyCategoriesLoading ||
                          state is GetEmergencyCategoriesInitial) {
                        return const EmergencyCategoriesShimmer();
                      }

                      if (state is GetEmergencyCategoriesError) {
                        return RefreshIndicator(
                          color: colors.whiteColor,
                          backgroundColor: colors.main,
                          onRefresh: _onRefresh,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: constraints.maxHeight,
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                      ),
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: colors.whiteColor,
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                      child: ErrorText(
                                        width: 280.w,
                                        text: state.message,
                                        onRetry: () {
                                          context
                                              .read<
                                                GetEmergencyCategoriesCubit
                                              >()
                                              .getEmergencyCategories();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      final categories = _activeCategories(state);

                      if (categories.isEmpty) {
                        return RefreshIndicator(
                          color: colors.whiteColor,
                          backgroundColor: colors.main,
                          onRefresh: _onRefresh,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: constraints.maxHeight,
                                  child: Center(
                                    child: Text(
                                      'no_categories_found'.tr,
                                      style: TextStyles.medium16(
                                        color: colors.whiteColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: colors.whiteColor,
                        backgroundColor: colors.main,
                        onRefresh: _onRefresh,
                        child: Center(
                          child: SizedBox(
                            width: screenWidth * 0.75,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: categories.length,
                              separatorBuilder: (_, _) => Gaps.vGap20,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return EmergencyCategoryCard(
                                  item: category,
                                  onTap: () => _openCategory(category),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
