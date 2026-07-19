import 'package:alhakim/config/locale/app_localizations.dart';
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

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetHospitalEmergencyCubit>().getHospitalEmergencyNumbers();
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
              child: CustomAppBar(title: 'emergency'.tr, isInTabBar: false),
            ),

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
                              context
                                  .read<GetHospitalEmergencyCubit>()
                                  .getHospitalEmergencyNumbers();
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
                        return ErrorText(
                          width: 300.w,
                          text: 'no_hospitals_found'.tr,
                        );
                      }

                      return RefreshIndicator(
                        color: colors.main,
                        onRefresh: () async {
                          await context
                              .read<GetHospitalEmergencyCubit>()
                              .getHospitalEmergencyNumbers();
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
