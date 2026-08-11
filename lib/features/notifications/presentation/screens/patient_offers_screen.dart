import 'dart:async';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/shimmer/hospital_emergency_shimmer.dart';
import 'package:alhakim/features/settings/domain/entity/hospital_emergency_entity.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_hospital_emergency_cubit/get_hospital_emergency_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/features/settings/presentaion/widgets/hospital_emergency_card.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientOffersScreen extends StatefulWidget {
  final bool isInTabBar;
  const PatientOffersScreen({super.key, this.isInTabBar = false});

  @override
  State<PatientOffersScreen> createState() => _PatientOffersScreenState();
}

class _PatientOffersScreenState extends State<PatientOffersScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchHospitals({String? hospitalName}) {
    context.read<GetHospitalEmergencyCubit>().getHospitalEmergencyNumbers(
      hospitalName: hospitalName,
      isOffered: 1,
    );
  }

  void _onSearchChanged(String? value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _fetchHospitals(hospitalName: (value ?? '').trim());
    });
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
                title: 'patient_offers'.tr,
                isInTabBar: widget.isInTabBar,
              ),
            ),
            Gaps.vGap8,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: colors.main.withValues(alpha: .1),
                      blurRadius: 10.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: MyTextFormField(
                  controller: _searchController,
                  backgroundColor: colors.whiteColor,
                  hintText: 'searchForPlace'.tr,
                  prefixIcon: Icon(Icons.search, color: colors.main),
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                ),
              ),
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
                              _fetchHospitals(
                                hospitalName: _searchController.text.trim(),
                              );
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
                          _fetchHospitals(
                            hospitalName: _searchController.text.trim(),
                          );
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
