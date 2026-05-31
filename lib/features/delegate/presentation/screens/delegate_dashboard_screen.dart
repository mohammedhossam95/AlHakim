import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/delegate/domain/entities/representative_stats_entity.dart';
import 'package:alhakim/features/delegate/presentation/cubit/get_representative_stats_cubit/get_representative_stats_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DelegateDashboardScreen extends StatefulWidget {
  const DelegateDashboardScreen({super.key});

  @override
  State<DelegateDashboardScreen> createState() =>
      _DelegateDashboardScreenState();
}

class _DelegateDashboardScreenState extends State<DelegateDashboardScreen> {
  @override
  void initState() {
    super.initState();

    context.read<GetRepresentativeStatsCubit>().getRepresentativeStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,

      body: BlocBuilder<GetRepresentativeStatsCubit, GetRepresentativeStatsState>(
        builder: (context, state) {
          if (state is GetRepresentativeStatsLoading) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),

                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,

                  highlightColor: Colors.grey.shade100,

                  child: Column(
                    children: [
                      /// header
                      Row(
                        children: [
                          Container(
                            height: 60.h,
                            width: 60.w,

                            decoration: const BoxDecoration(
                              color: Colors.white,

                              shape: BoxShape.circle,
                            ),
                          ),

                          Gaps.hGap12,

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Container(
                                  height: 12.h,
                                  width: 120.w,
                                  color: Colors.white,
                                ),

                                Gaps.vGap8,

                                Container(
                                  height: 16.h,
                                  width: 80.w,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Gaps.vGap20,

                      /// invite card
                      Container(
                        height: 120.h,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),

                      Gaps.vGap20,

                      /// grid shimmer
                      GridView.builder(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: 6,

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,

                          mainAxisSpacing: 12.h,

                          crossAxisSpacing: 12.w,

                          childAspectRatio: 1.2,
                        ),

                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          RepresentativeStatsEntity? stats;

          if (state is GetRepresentativeStatsSuccess) {
            stats = state.response.data as RepresentativeStatsEntity?;
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// header
                    Row(
                      children: [
                        DiffImage(
                          image: sharedPreferences
                              .getAuth()
                              ?.user
                              ?.profilePhotoUrl,

                          height: 60,
                          width: 60,

                          isCircle: true,

                          userName:
                              "${sharedPreferences.getAuth()?.user?.firstName}",
                        ),

                        Gaps.hGap12,

                        Text(
                          "welcome".tr,

                          style: TextStyles.medium14(
                            color: colors.lightTextColor,
                          ),
                        ),

                        Gaps.hGap4,

                        Text(
                          sharedPreferences.getAuth()?.user?.firstName ?? '',

                          style: TextStyles.semiBold14(),
                        ),

                        const Spacer(),

                        Container(
                          padding: EdgeInsets.all(10.w),

                          decoration: BoxDecoration(
                            color: colors.main.withValues(alpha: .12),

                            borderRadius: BorderRadius.circular(14.r),
                          ),

                          child: Icon(
                            Icons.notifications_none,

                            color: colors.main,
                          ),
                        ),
                      ],
                    ),

                    Gaps.vGap12,

                    /// invite card
                    _InviteCard(
                      code:
                          sharedPreferences.getAuth()?.user?.referralCode ??
                          'N/A',
                    ),

                    Gaps.vGap20,

                    /// clinics
                    _DashboardSection(
                      title: "clinics_statistics".tr,

                      icon: Icons.local_hospital_outlined,

                      color: colors.main,

                      items: [
                        _DashboardItem(
                          title: "total_clinics".tr,

                          value: "${stats?.clinics?.total ?? 0}",

                          icon: Icons.apartment_outlined,

                          color: colors.main,
                        ),

                        _DashboardItem(
                          title: "active_clinics".tr,

                          value: "${stats?.clinics?.active ?? 0}",

                          icon: Icons.check_circle_outline,

                          color: colors.success,
                        ),

                        _DashboardItem(
                          title: "inactive_clinics".tr,

                          value: "${stats?.clinics?.inactive ?? 0}",

                          icon: Icons.cancel_outlined,

                          color: colors.errorColor,
                        ),

                        _DashboardItem(
                          title: "open_clinics".tr,

                          value: "${stats?.clinics?.open ?? 0}",

                          icon: Icons.lock_open_outlined,

                          color: colors.secondary,
                        ),

                        _DashboardItem(
                          title: "closed_clinics".tr,

                          value: "${stats?.clinics?.closed ?? 0}",

                          icon: Icons.lock_outline,

                          color: colors.textColor,
                        ),

                        _DashboardItem(
                          title: "average_rating".tr,

                          value: "${stats?.clinics?.avgRating ?? 0}",

                          icon: Icons.star_outline,

                          color: colors.review,
                        ),
                      ],
                    ),

                    // Gaps.vGap20,

                    // /// appointments
                    // _DashboardSection(
                    //   title: "appointments_statistics".tr,

                    //   icon: Icons.calendar_month_outlined,

                    //   color: colors.secondary,

                    //   items: [
                    //     _DashboardItem(
                    //       title: "total_appointments".tr,

                    //       value: "${stats?.appointments?.total ?? 0}",

                    //       icon: Icons.calendar_today_outlined,

                    //       color: colors.main,
                    //     ),

                    //     _DashboardItem(
                    //       title: "pending_appointments".tr,

                    //       value: "${stats?.appointments?.pending ?? 0}",

                    //       icon: Icons.schedule_outlined,

                    //       color: colors.textColor,
                    //     ),

                    //     _DashboardItem(
                    //       title: "confirmed_appointments".tr,

                    //       value: "${stats?.appointments?.confirmed ?? 0}",

                    //       icon: Icons.check_circle_outline,

                    //       color: colors.success,
                    //     ),

                    //     _DashboardItem(
                    //       title: "cancelled_appointments".tr,

                    //       value: "${stats?.appointments?.cancelled ?? 0}",

                    //       icon: Icons.cancel_outlined,

                    //       color: colors.errorColor,
                    //     ),

                    //     _DashboardItem(
                    //       title: "completed_appointments".tr,

                    //       value: "${stats?.appointments?.completed ?? 0}",

                    //       icon: Icons.task_alt_outlined,

                    //       color: colors.secondary,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardSection extends StatelessWidget {
  final String title;

  final IconData icon;

  final Color color;

  final List<Widget> items;

  const _DashboardSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: colors.whiteColor,

        borderRadius: BorderRadius.circular(20.r),
      ),

      child: Column(
        children: [
          /// top
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),

                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),

                  borderRadius: BorderRadius.circular(14.r),
                ),

                child: Icon(icon, color: color),
              ),

              Gaps.hGap12,

              Expanded(
                child: Text(
                  title,

                  style: TextStyles.semiBold16(),

                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),

          Gaps.vGap18,

          /// grid
          GridView.builder(
            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            itemCount: items.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,

              mainAxisSpacing: 12.h,

              crossAxisSpacing: 12.w,

              childAspectRatio: 0.90,
            ),

            itemBuilder: (context, index) {
              return items[index];
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final String title;

  final String value;

  final IconData icon;

  final Color color;

  const _DashboardItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),

      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),

        borderRadius: BorderRadius.circular(18.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          /// icon
          Container(
            padding: EdgeInsets.all(14.w),

            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),

              borderRadius: BorderRadius.circular(12.r),
            ),

            child: Icon(icon, color: color, size: 24.sp),
          ),

          Gaps.vGap10,

          /// title
          Text(
            title,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            textAlign: TextAlign.right,

            style: TextStyles.medium13(),
          ),

          Gaps.vGap16,

          /// value
          Text(value, style: TextStyles.semiBold20(color: color)),
        ],
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  final String code;

  const _InviteCard({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(30.w),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),

        gradient: LinearGradient(colors: [colors.main, colors.secondary]),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// title
          Text(
            "expand_network_today".tr,

            style: TextStyles.semiBold18(color: colors.whiteColor),

            textAlign: TextAlign.right,
          ),

          Gaps.vGap16,

          /// desc
          Text(
            "expand_network_desc".tr,

            style: TextStyles.semiBold12(
              color: colors.whiteColor.withValues(alpha: .9),
            ),

            textAlign: TextAlign.right,
          ),

          Gaps.vGap16,

          /// code
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),

            decoration: BoxDecoration(
              color: colors.whiteColor.withValues(alpha: .15),

              borderRadius: BorderRadius.circular(16.r),
            ),

            child: Row(
              textDirection: TextDirection.rtl,

              children: [
                /// copy
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));

                    Constants.showSnakToast(
                      context: context,

                      message: "code_copied".tr,

                      type: 1,
                    );
                  },

                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,

                      vertical: 6.h,
                    ),

                    decoration: BoxDecoration(
                      color: colors.whiteColor,

                      borderRadius: BorderRadius.circular(10.r),
                    ),

                    child: Text(
                      "copy_code".tr,

                      style: TextStyles.medium12(color: colors.main),
                    ),
                  ),
                ),

                Gaps.hGap12,

                /// code text
                Expanded(
                  child: Text(
                    code,

                    style: TextStyles.semiBold16(color: colors.whiteColor),

                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
