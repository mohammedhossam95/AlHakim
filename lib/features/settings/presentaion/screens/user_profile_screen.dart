import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/features/home/domain/entity/product_entity.dart';
import 'package:alhakim/features/home/presentation/cubit/all_ads_cubit/all_ads_cubit.dart';
import 'package:alhakim/features/home/presentation/cubit/all_ads_cubit/all_ads_state.dart';
import 'package:alhakim/features/home/presentation/widgets/shimmer.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_user_profile_cubit/get_user_profile_cubit.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../injection_container.dart';

class UserProfileScreen extends StatefulWidget {
  final int? userId;
  const UserProfileScreen({super.key, this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetUserProfileCubit>().getUserProfile(
      AuthParams(userId: widget.userId),
    );
    context.read<AllAdsCubit>().getAds(adId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.main,
        elevation: 0,
        title: Text(
          'ملف المالك',
          style: TextStyles.bold16(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: colors.whiteColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<GetUserProfileCubit, GetUserProfileState>(
              builder: (context, state) {
                if (state is GetUserProfileIsLoading) {
                  return _buildShimmer();
                } else if (state is GetUserProfileError) {
                  return ErrorText(
                    width: ScreenUtil().screenWidth * 0.5,
                    text: state.message,
                  );
                } else if (state is GetUserProfileLoaded) {
                  final user = state.response.data as UserEntity?;
                  if (user == null) {
                    return Center(
                      child: ErrorText(
                        width: ScreenUtil().screenWidth * 0.5,
                        text: 'noData'.tr,
                      ),
                    );
                  }
                  return _buildHeaderSection(user);
                }
                return const SizedBox();
              },
            ),
            BlocBuilder<AllAdsCubit, AllAdsState>(
              builder: (context, state) {
                final cubit = context.read<AllAdsCubit>();
                final ads = cubit.ads;
                final hasMore = cubit.hasMore;

                /// Initial loading or states where ads are empty and we are fetching
                if (ads.isEmpty) {
                  if (state is AllAdsLoading ||
                      state is AllAdsInitial ||
                      state is AllAdsPaginationLoading) {
                    return const ProductShimmerItem();
                  }

                  if (state is AllAdsSuccess) {
                    return SizedBox(
                      height: 300.h,
                      child: Center(
                        child: ErrorText(
                          width: ScreenUtil().screenWidth * 0.7,
                          text: 'noData'.tr,
                        ),
                      ),
                    );
                  }
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hasMore ? ads.length + 1 : ads.length,
                  itemBuilder: (context, index) {
                    /// Pagination loader
                    if (index >= ads.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: ProductShimmerItem(),
                      );
                    }

                    final ad = ads[index];

                    final imageUrl = (ad.photos?.isNotEmpty ?? false)
                        ? ad.photos!.first.url ?? ''
                        : '';

                    final product = ProductEntity(
                      id: ad.id ?? 0,
                      categoryName: '',
                      title: ad.title ?? '',
                      finalPrice:
                          double.tryParse(ad.price?.toString() ?? '0') ?? 0,
                      image: imageUrl,
                      isFavorite: ad.isFavorite,
                      city: CityEntity(
                        id: ad.city?.id ?? 0,
                        name: ad.city?.name ?? '',
                      ),
                    );

                    return InkWell(
                      onTap: () {
                        context.pushNamed(
                          Routes.productDetailsScreenRoute,
                          extra: product,
                        );
                      },
                      child: Container(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(UserEntity user) {
    final name = user.name ?? 'غير معروف';
    final email = user.email ?? '';
    final phone = user.phone ?? '';
    final country = user.countryCode ?? '';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    Widget infoRow(IconData icon, String text) {
      if (text.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: colors.main),
            Gaps.hGap6,
            Expanded(
              child: Text(
                text,
                style: TextStyles.medium14(
                  color: colors.main.withValues(alpha: 0.6),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Container(
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.main.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: colors.textColor.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 36.r,
                backgroundColor: colors.main,
                child: Text(
                  initials,
                  style: TextStyles.bold20(color: Colors.white),
                ),
              ),
            ),
            Gaps.vGap8,
            Center(
              child: Text(
                name,
                style: TextStyles.semiBold16(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Gaps.vGap8,
            infoRow(Icons.email_outlined, email),
            infoRow(Icons.phone_outlined, phone),
            infoRow(Icons.location_on_outlined, country),

            Gaps.vGap20,

            /// CHAT BUTTON
            MyDefaultButton(
              btnText: 'بدا محادثة',
              localeText: true,
              onPressed: () {},
              color: Colors.white,
              textColor: colors.main,
              borderColor: colors.main,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: colors.lightTextColor.withValues(alpha: 0.2),
      highlightColor: colors.lightTextColor.withValues(alpha: 0.2),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 16.h,
                        color: colors.lightTextColor.withValues(alpha: 6),
                      ),
                      Gaps.vGap8,
                      Container(
                        height: 14.h,
                        width: 150.w,
                        color: colors.lightTextColor.withValues(alpha: 6),
                      ),
                      Gaps.vGap8,
                      Container(
                        height: 14.h,
                        width: 100.w,
                        color: colors.lightTextColor.withValues(alpha: 6),
                      ),
                      Gaps.vGap8,
                      Container(
                        height: 14.h,
                        width: 120.w,
                        color: colors.lightTextColor.withValues(alpha: 6),
                      ),
                    ],
                  ),
                ),
                Gaps.hGap10,
                CircleAvatar(
                  radius: 35.r,
                  backgroundColor: colors.lightTextColor.withValues(alpha: 6),
                ),
              ],
            ),
            Gaps.vGap10,
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 20.h,
                  width: 50.w,
                  color: colors.lightTextColor.withValues(alpha: 6),
                ),
                Container(
                  height: 20.h,
                  width: 50.w,
                  color: colors.lightTextColor.withValues(alpha: 6),
                ),
              ],
            ),
            Gaps.vGap10,
            Container(
              height: 45.h,
              width: double.infinity,
              color: colors.lightTextColor.withValues(alpha: 6),
            ),
          ],
        ),
      ),
    );
  }
}
