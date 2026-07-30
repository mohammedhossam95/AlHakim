import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/shimmer/hospital_emergency_shimmer.dart';
import 'package:alhakim/features/settings/domain/entity/emergency_category_entity.dart';
import 'package:alhakim/features/settings/domain/entity/hospital_emergency_entity.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_emergency_categories_cubit/get_emergency_categories_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_hospital_emergency_cubit/get_hospital_emergency_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/features/settings/presentaion/widgets/emergency_categories_list.dart';
import 'package:alhakim/features/settings/presentaion/widgets/hospital_emergency_card.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyScreen extends StatefulWidget {
  final bool isInTabBar;
  const EmergencyScreen({super.key, this.isInTabBar = false});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<GetEmergencyCategoriesCubit>().getEmergencyCategories();
    _fetchHospitals();
  }

  void _fetchHospitals({int? categoryId}) {
    context.read<GetHospitalEmergencyCubit>().getHospitalEmergencyNumbers(
      categoryId: categoryId,
    );
  }

  void _onCategorySelected(int? categoryId) {
    if (_selectedCategoryId == categoryId) return;
    setState(() => _selectedCategoryId = categoryId);
    _fetchHospitals(categoryId: categoryId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: CustomAppBar(
                title: 'emergency'.tr,
                isInTabBar: widget.isInTabBar,
              ),
            ),
            Gaps.vGap8,
            BlocBuilder<
              GetEmergencyCategoriesCubit,
              GetEmergencyCategoriesState
            >(
              builder: (context, state) {
                if (state is GetEmergencyCategoriesLoading ||
                    state is GetEmergencyCategoriesInitial) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      height: 44.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        separatorBuilder: (_, _) => SizedBox(width: 8.w),
                        itemBuilder: (_, _) => Container(
                          width: 90.w,
                          decoration: BoxDecoration(
                            color: colors.whiteColor,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (state is GetEmergencyCategoriesError) {
                  return EmergencyCategoriesList(
                    categories: const [],
                    selectedCategoryId: _selectedCategoryId,
                    onCategorySelected: _onCategorySelected,
                  );
                }

                return EmergencyCategoriesList(
                  categories: _activeCategories(state),
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: _onCategorySelected,
                );
              },
            ),
            Gaps.vGap20,
            Expanded(
              child:
                  BlocBuilder<
                    GetHospitalEmergencyCubit,
                    GetHospitalEmergencyState
                  >(
                    builder: (context, state) {
                      if (state is GetHospitalEmergencyLoading ||
                          state is GetHospitalEmergencyInitial) {
                        return const HospitalEmergencyShimmer();
                      }

                      if (state is GetHospitalEmergencyError) {
                        return Center(
                          child: ErrorText(
                            width: 300.w,
                            text: state.message,
                            onRetry: () {
                              _fetchHospitals(categoryId: _selectedCategoryId);
                            },
                          ),
                        );
                      }

                      final items = state is GetHospitalEmergencySuccess
                          ? (state.response.data ?? [])
                                .whereType<HospitalEmergencyEntity>()
                                .toList()
                          : <HospitalEmergencyEntity>[];

                      if (items.isEmpty) {
                        return Center(
                          child: ErrorText(
                            width: 300.w,
                            text: 'no_hospitals_found'.tr,
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: colors.main,
                        onRefresh: () async {
                          _fetchHospitals(categoryId: _selectedCategoryId);
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                          itemCount: items.length,
                          separatorBuilder: (_, _) => Gaps.vGap16,
                          itemBuilder: (context, index) {
                            return HospitalEmergencyCard(item: items[index]);
                          },
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
