import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/notifications/presentation/cubits/notifications_count_cubit/notifications_count_cubit.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialties_cubit/get_specialties_cubit.dart';
import 'package:alhakim/features/specialities/presentation/widgets/speciality_item.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class SpecialitiesScreen extends StatefulWidget {
  const SpecialitiesScreen({super.key});

  @override
  State<SpecialitiesScreen> createState() => _SpecialitiesScreenState();
}

class _SpecialitiesScreenState extends State<SpecialitiesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GetSpecialtiesCubit>().getSpecialties();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Row(
                children: [
                  DiffImage(
                    image: sharedPreferences.getAuth()?.user?.profilePhotoUrl,

                    height: 60,
                    width: 60,
                    isCircle: true,

                    userName: "${sharedPreferences.getAuth()?.user?.firstName}",
                  ),

                  Gaps.hGap12,

                  Text(
                    "welcome".tr,

                    style: TextStyles.medium14(color: colors.lightTextColor),
                  ),

                  Gaps.hGap4,

                  Text(
                    sharedPreferences.getAuth()?.user?.firstName ?? '',

                    style: TextStyles.semiBold14(),
                  ),

                  const Spacer(),

                  BlocBuilder<SessionCubit, SessionState>(
                    builder: (context, sessionState) {
                      if (sessionState.status != SessionStatus.authenticated) {
                        return const SizedBox.shrink();
                      }

                      return BlocProvider(
                        create: (_) =>
                            ServiceLocator.instance<NotificationsCountCubit>()
                              ..fGetCount(),
                        child:
                            BlocBuilder<
                              NotificationsCountCubit,
                              NotificationsCountState
                            >(
                              builder: (context, countState) {
                                final unreadCount =
                                    countState
                                        is NotificationsCountSuccessState
                                    ? countState.unreadCount
                                    : 0;

                                return InkWell(
                                  onTap: () {
                                    context.push(
                                      Routes.notificationsScreenRoute,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(14.r),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10.w),
                                        decoration: BoxDecoration(
                                          color: colors.main.withValues(
                                            alpha: .12,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14.r,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.notifications_none,
                                          color: colors.main,
                                        ),
                                      ),
                                      if (unreadCount > 0)
                                        Positioned(
                                          top: -2.h,
                                          right: -2.w,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                              vertical: 1.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colors.errorColor,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 16.w,
                                            ),
                                            child: Text(
                                              unreadCount > 99
                                                  ? '99+'
                                                  : '$unreadCount',
                                              textAlign: TextAlign.center,
                                              style: TextStyles.bold10(
                                                color: colors.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      );
                    },
                  ),
                ],
              ),
              Gaps.vGap10,

              ///  search field
              Container(
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
                  hintText: 'search_speciality'.tr,
                  prefixIcon: Icon(Icons.search, color: colors.main),
                  textInputAction: TextInputAction.search,
                  onSubmit: (value) {
                    final query = value.trim();
                    if (query.isEmpty) return;

                    context.push(
                      Routes.searchDoctorsScreenRoute,
                      extra: query, // أو arguments حسب الراوتر اللي بتستخدمه
                    );
                  },
                ),
              ),
              Gaps.vGap16,

              /// banner
              _BannerCard(),
              Gaps.vGap16,

              /// header
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("all_specialities".tr, style: TextStyles.semiBold16()),
                  // Text(
                  //   "see_all".tr,
                  //   style: TextStyles.medium14(color: colors.main),
                  // ),
                ],
              ),

              Gaps.vGap16,

              /// grid
              Expanded(
                child: BlocBuilder<GetSpecialtiesCubit, GetSpecialtiesState>(
                  builder: (context, state) {
                    if (state is GetSpecialtiesLoading) {
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 6,

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14.h,
                          crossAxisSpacing: 14.w,
                          childAspectRatio: .88,
                        ),

                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              padding: EdgeInsets.all(14.w),

                              decoration: BoxDecoration(
                                color: colors.whiteColor,
                                borderRadius: BorderRadius.circular(22.r),
                              ),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /// image shimmer
                                  Container(
                                    height: 70.h,
                                    width: 70.w,

                                    decoration: BoxDecoration(
                                      color: colors.whiteColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),

                                  Gaps.vGap16,

                                  /// title shimmer
                                  Container(
                                    height: 12.h,
                                    width: 90.w,

                                    decoration: BoxDecoration(
                                      color: colors.whiteColor,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),

                                  Gaps.vGap10,

                                  Container(
                                    height: 10.h,
                                    width: 60.w,

                                    decoration: BoxDecoration(
                                      color: colors.whiteColor,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is GetSpecialtiesError) {
                      return SizedBox(
                        height: 150.h,
                        child: Center(
                          child: ErrorText(
                            width: 100.w,
                            text: state.message,
                            onRetry: () => context
                                .read<GetSpecialtiesCubit>()
                                .getSpecialties(),
                          ),
                        ),
                      );
                    } else if (state is GetSpecialtiesSuccess) {
                      final List<SpecialtyEntity> specialities =
                          state.response.data as List<SpecialtyEntity>;

                      if (specialities.isEmpty) {
                        return Center(
                          child: ErrorText(width: 300.w, text: "noData".tr),
                        );
                      }
                      return GridView.builder(
                        padding: EdgeInsets.only(bottom: 20.h),

                        itemCount: specialities.length,

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14.h,
                          crossAxisSpacing: 14.w,
                          childAspectRatio: .75,
                        ),

                        itemBuilder: (context, index) {
                          final item = specialities[index];

                          return SpecialityItem(item);
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Search field navigates to SearchDoctorsScreen

class _BannerCard extends StatelessWidget {
  const _BannerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: colors.main,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔝 icon (top right)
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const SizedBox(),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: colors.whiteColor.withValues(alpha: .15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology,
                  color: colors.whiteColor,
                  size: 18.sp,
                ),
              ),
              Gaps.hGap6,
              Text(
                "agent_title".tr,
                style: TextStyles.semiBold18(color: colors.whiteColor),
              ),
            ],
          ),
          Gaps.vGap8,
          Text(
            "ai_engine_desc".tr,
            style: TextStyles.medium14(
              color: colors.whiteColor.withValues(alpha: .85),
            ),
          ),
          Gaps.vGap20,

          /// 🔘 button
          Align(
            alignment: Alignment.centerRight,
            child: MyDefaultButton(
              borderColor: colors.whiteColor,
              onPressed: () {
                context.push(Routes.agentScreenRoute);
              },
              btnText: "start_diagnosis",
              color: colors.whiteColor,
              svgAsset: SvgAssets.iconArrowBackEn,
              textColor: colors.main,
              textStyle: TextStyles.semiBold12(color: colors.main),
              width: ScreenUtil().screenWidth * .45,
              height: 40.h,
            ),
          ),
        ],
      ),
    );
  }
}
