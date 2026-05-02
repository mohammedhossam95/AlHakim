import 'dart:async';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/features/home/presentation/cubit/all_ads_cubit/all_ads_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/language_setting_widget.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

// ---  Custom Marketplace Header ---
class CustomMarketplaceHeader extends StatefulWidget {
  final TextEditingController searchController;
  final UserEntity user;
  const CustomMarketplaceHeader({
    super.key,
    required this.searchController,
    required this.user,
  });

  @override
  State<CustomMarketplaceHeader> createState() =>
      _CustomMarketplaceHeaderState();
}

class _CustomMarketplaceHeaderState extends State<CustomMarketplaceHeader> {
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;

      if (!_isSearching) {
        widget.searchController.clear();
        context.read<AllAdsCubit>().getAds();
      }
    });
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<AllAdsCubit>().getAds(search: value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: colors.whiteColor,
      pinned: true,
      leading: !_isSearching
          ? InkWell(
              onTap: () {
                context.pushNamed(Routes.editProfileScreenRoute);
              },
              child: Center(
                child: DiffImage(
                  image: widget.user.profileImageUrl ?? '',
                  userName: widget.user.name ?? '',
                  height: 40.h,
                  isCircle: true,
                  width: 40.w,
                  radius: 20.r,
                  padding: EdgeInsets.all(4.r),
                  hasBorder: true,
                ),
              ),
            )
          : IconButton(
              icon: Icon(Icons.arrow_back, color: colors.secondary),
              onPressed: _toggleSearch,
            ),
      titleSpacing: 0,
      title: _isSearching
          ? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16,
              ),
              child: MyTextFormField(
                controller: widget.searchController,
                hintText: 'search'.tr,
                borderColor: colors.secondary.withValues(alpha: 0.3),
                backgroundColor: Colors.white,
                radius: 8.r,
                onChanged: (value) {
                  _onSearchChanged(value ?? '');
                },
                prefixIcon: Icon(Icons.search, color: colors.secondary),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: (Constants.isAuth(context))
                      ? Text(widget.user.name ?? '')
                      : InkWell(
                          onTap: () {
                            context.pushNamed(Routes.loginScreenRoute);
                          },
                          child: Text(
                            'login'.tr,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.secondary,
                            ),
                          ),
                        ),
                ),
              ],
            ),

      actions: _isSearching
          ? []
          : [
              InkWell(
                onTap: () {
                  Constants.buildCustomShowModel(
                    context: context,
                    child: const LanguageSettingWidget(),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    children: [
                      Text(
                        appLocalizations.isEnLocale ? 'EN' : 'AR',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: colors.secondary,
                        ),
                      ),
                      Gaps.hGap4,
                      SvgPicture.asset(
                        SvgAssets.languageIcon,
                        colorFilter: ColorFilter.mode(
                          colors.secondary,
                          BlendMode.srcIn,
                        ),
                        height: 22.h,
                      ),
                    ],
                  ),
                ),
              ),

              /// SEARCH ICON
              InkWell(
                onTap: _toggleSearch,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Icon(
                    Icons.search,
                    size: 24.sp,
                    color: colors.secondary,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Icon(
                    Icons.notifications_none_outlined,
                    size: 28.sp,
                    color: colors.secondary,
                  ),
                ),
              ),
            ],
    );
  }
}
