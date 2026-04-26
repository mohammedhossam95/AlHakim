import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/assets.dart';
import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/settings/domain/entity/app_setting_entity.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/features/settings/presentaion/widgets/language_setting_widget.dart';
import 'package:alhakim/features/settings/presentaion/widgets/profile_widget.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '/config/routes/app_routes.dart';
import '/core/utils/constants.dart';
import '/core/utils/enums.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '../cubit/app_setting_cubit/app_setting_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppSettingCubit>().getAppsetting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, sessionState) {
        return RefreshIndicator(
          onRefresh: () => context.read<AppSettingCubit>().getAppsetting(),
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        children: [
                          CustomAppBar(
                            title: 'my_profile'.tr,
                            isInTabBar: true,
                          ),
                          Spacer(),
                          (sessionState.status == SessionStatus.authenticated)
                              ? InkWell(
                                  onTap: () async {
                                    _handleLogout();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: colors.errorColor,
                                        size: 20.sp,
                                      ),
                                      Gaps.hGap6,
                                      Text(
                                        'logout'.tr,
                                        style: TextStyles.semiBold12(
                                          color: colors.errorColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                      Gaps.vGap16,
                      if (sessionState.status ==
                          SessionStatus.authenticated) ...[
                        _buildSectionCard(
                          child: Column(
                            children: [
                              ProfileWidet(
                                title: 'tapBarItemMyAccount'.tr,
                                icon: SvgAssets.editProfileIcon,
                                onTap: () {
                                  context.push(Routes.editProfileScreenRoute);
                                },
                              ),
                              // ProfileWidet(
                              //   title: 'my_addresses'.tr,
                              //   icon: SvgAssets.location,
                              //   onTap: () {
                              //     // context.push(
                              //     //   Routes.mainPageRoute,
                              //     //   extra: false,
                              //     // );
                              //   },
                              // ),
                              ProfileWidet(
                                title: 'favorites'.tr,
                                icon: SvgAssets.favoritesIcon,
                                onTap: () {
                                  context.push(Routes.favoritesScreenRoute);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],

                      Gaps.vGap16,

                      _buildSectionCard(
                        title: 'settings_and_support'.tr,
                        child: Column(
                          children: [
                            ProfileWidet(
                              title: 'language'.tr,
                              icon: SvgAssets.languageIcon,
                              onTap: () {
                                Constants.buildCustomShowModel(
                                  context: context,
                                  child: const LanguageSettingWidget(),
                                );
                              },
                            ),
                            // if (sessionState.status ==
                            //     SessionStatus.authenticated)
                            //   ProfileWidet(
                            //     //done
                            //     title: 'contact_us'.tr,
                            //     icon: SvgAssets.contactUsIcon,
                            //     onTap: () {
                            //       context.push(Routes.contactUsRoute);
                            //     },
                            //   ),

                            // ProfileWidet(
                            //   //done
                            //   title: 'our_branches'.tr,
                            //   icon: SvgAssets.location,
                            //   onTap: () {
                            //     context.push(Routes.allBrancesRoute);
                            //   },
                            // ),
                            ProfileWidet(
                              title: 'terms_conditions'.tr,
                              icon: SvgAssets.termsIcon,
                              onTap: () {
                                context.push(
                                  Routes.staticPageScreenRoute,
                                  extra: StaticPageType.conditions,
                                );
                              },
                            ),
                            ProfileWidet(
                              title: 'how_we'.tr,
                              icon: SvgAssets.aboutAppIcon,
                              onTap: () {
                                context.push(
                                  Routes.staticPageScreenRoute,
                                  extra: StaticPageType.aboutUs,
                                );
                              },
                            ),
                            ProfileWidet(
                              title: 'privacy_policy'.tr,
                              icon: SvgAssets.privacyIcon,
                              onTap: () {
                                context.push(
                                  Routes.staticPageScreenRoute,
                                  extra: StaticPageType.privacy,
                                );
                              },
                            ),
                            ProfileWidet(
                              title: 'public_questions'.tr,
                              icon: SvgAssets.faqIcon,
                              onTap: () {
                                context.push(
                                  Routes.staticPageScreenRoute,
                                  extra: StaticPageType.faq,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      (sessionState.status == SessionStatus.authenticated)
                          ? SizedBox.shrink()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Gaps.vGap25,
                                MyDefaultButton(
                                  height: 40.h,
                                  borderRadius: 20.r,
                                  onPressed: () async {
                                    Constants.showLoading(context);
                                    await Future.delayed(Duration(seconds: 2));
                                    if (!context.mounted) return;
                                    Constants.hideLoading(context);
                                    context.push(Routes.loginScreenRoute);
                                  },
                                  btnText: 'login',
                                ),
                              ],
                            ),

                      BlocBuilder<AppSettingCubit, AppSettingState>(
                        builder: (context, state) {
                          if (state is AppSettingLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is AppSettingLoaded) {
                            final settings =
                                state.resp.data as List<AppSettingsEntity>;
                            return FadeInUp(
                              child: _buildAppInfoSection(settings),
                            );
                          }
                          if (state is AppSettingError) {
                            return ErrorText(
                              width: ScreenUtil().screenWidth * 0.6,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({String? title, required Widget child}) {
    return Container(
      width: ScreenUtil().screenWidth,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.lightBackGroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: TextStyles.bold12(color: colors.lightTextColor)),
            Gaps.vGap16,
          ],

          child,
        ],
      ),
    );
  }

  Widget _buildAppInfoSection(List<AppSettingsEntity> settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Gaps.vGap8,
          Image.asset(ImgAssets.logo, width: 80.w, height: 80.h),
          // Text(
          //   settings.appName ?? '',
          //   style: TextStyles.medium10(
          //     color: colors.lightTextColor.withValues(alpha: 0.8),
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          Gaps.vGap10,
          // Social Media Icons Row
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              _socialIcon(
                FontAwesomeIcons.tiktok,
                settings.tiktok,
                onTap: () => Constants.launchURL(settings.tiktok!),
              ),
              _socialIcon(
                FontAwesomeIcons.instagram,
                settings.instagram,
                onTap: () => Constants.launchURL(settings.instagram!),
              ),
              _socialIcon(
                FontAwesomeIcons.facebook,
                settings.facebook,
                onTap: () => Constants.launchURL(settings.facebook!),
              ),
              _socialIcon(
                FontAwesomeIcons.whatsapp,
                settings.whatsapp,
                onTap: () =>
                    Constants.launchURL("https://wa.me/${settings.whatsapp}"),
              ),

              _socialIcon(
                Icons.email,
                settings.support,
                onTap: () => Constants.launchURL("mailto:${settings.support}"),
              ),
              _socialIcon(
                FontAwesomeIcons.xTwitter,
                settings.twitter,
                onTap: () {
                  if (settings.twitter != null) {
                    Constants.launchURL(settings.twitter!);
                  }
                },
              ),
              _socialIcon(
                FontAwesomeIcons.snapchat,
                settings.snapchat,
                onTap: () {
                  if (settings.snapchat != null) {
                    Constants.launchURL(settings.snapchat!);
                  }
                },
              ),
              _socialIcon(
                FontAwesomeIcons.youtube,
                settings.youtube,
                onTap: () {
                  if (settings.snapchat != null) {
                    Constants.launchURL(settings.youtube!);
                  }
                },
              ),
              _socialIcon(
                FontAwesomeIcons.linkedin,
                settings.linkedIn,
                onTap: () {
                  if (settings.snapchat != null) {
                    Constants.launchURL(settings.linkedIn!);
                  }
                },
              ),
            ],
          ),
          Gaps.vGap10,
          Text(
            'all_rights_reserved'.tr,
            style: TextStyles.medium10(
              color: colors.lightTextColor.withValues(alpha: 0.5),
            ),
          ),
          Gaps.vGap54,
          Gaps.vGap54,
        ],
      ),
    );
  }

  Widget _socialIcon(
    IconData icon,
    String? value, {
    required VoidCallback onTap,
  }) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(6.r),
          margin: EdgeInsets.only(top: 2.h),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withValues(alpha: 0.1),
          ),
          child: Icon(icon, size: 22.sp, color: Colors.black87),
        ),
      ),
    );
  }

  void _handleLogout() {
    Constants.showLoading(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Constants.hideLoading(context);
      BlocProvider.of<SessionCubit>(context).logout();
      BlocProvider.of<BottomNavBarCubit>(context).changeCurrentScreen(index: 0);
    });
  }
}

extension AppSettingsListX on List<AppSettingsEntity> {
  // Helper to find value by key safely
  String? _get(String key) {
    try {
      return firstWhere((element) => element.key == key).value;
    } catch (_) {
      return null; // Return null if key is not found
    }
  }

  // Define getters for each field used in your UI
  String? get appName => _get('name');
  String? get tiktok => _get('tiktok');
  String? get instagram => _get('instagram');
  String? get facebook => _get('facebook');
  String? get whatsapp =>
      _get('phone'); // Based on your JSON, phone is the whatsapp
  String? get twitter => _get('twitter');
  String? get snapchat => _get('snapchat');
  String? get support => _get('email');
  String? get youtube => _get('youtube');
  String? get linkedIn => _get('linkedin');
}
