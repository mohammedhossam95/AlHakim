import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/presentation/cubit/delete_user_account/delete_user_account_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/settings/domain/entity/app_setting_entity.dart';
import 'package:alhakim/features/settings/presentaion/cubit/app_setting_cubit/app_setting_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/features/settings/presentaion/widgets/language_setting_widget.dart';
import 'package:alhakim/features/settings/presentaion/widgets/profile_widget.dart';
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
    return BlocListener<DeleteUserAccountCubit, DeleteUserAccountState>(
      listener: (context, state) async {
        if (state is DeleteUserAccountLoading && state.isLoading) {
          Constants.showLoading(context);
        } else if (state is DeleteUserAccountLoaded) {
          if (mounted) Constants.hideLoading(context);
          Constants.showSnakToast(
            context: context,
            type: 1,
            message: state.response.message ?? 'delete_account_success'.tr,
          );
          await _clearSessionAndNavigate();
        } else if (state is DeleteUserAccountError) {
          if (mounted) Constants.hideLoading(context);
          Constants.showSnakToast(
            context: context,
            type: 3,
            message: state.message,
          );
        }
      },
      child: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
          return SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        children: [
                          CustomAppBar(title: 'settings'.tr, isInTabBar: true),
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
                              if (sessionCubit.state.userType ==
                                  UserType.patient) ...[
                                ProfileWidet(
                                  title: 'tapBarItemMyAccount'.tr,
                                  icon: SvgAssets.editProfileIcon,
                                  onTap: () {
                                    context.push(Routes.editProfileScreenRoute);
                                  },
                                ),
                                ProfileWidet(
                                  title: 'family_members'.tr,
                                  icon: SvgAssets.familyIcon,
                                  onTap: () {
                                    context.push(
                                      Routes.familyMembersScreenRoute,
                                    );
                                  },
                                ),
                              ],
                              ProfileWidet(
                                title: 'changePassword'.tr,
                                icon: SvgAssets.lock,
                                onTap: () {
                                  context.push(
                                    Routes.changePasswordScreenRoute,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],

                      _buildSectionCard(
                        title: 'settings_and_support'.tr,
                        child: Column(
                          children: [
                            if (sessionState.status !=
                                SessionStatus.authenticated)
                              ProfileWidet(
                                title: 'login_as_delegate'.tr,
                                icon: SvgAssets.user,
                                onTap: () {
                                  context.pushNamed(
                                    Routes.loginScreenRoute,
                                    extra: UserType.delegate,
                                  );
                                },
                              ),
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
                                    context.push(
                                      Routes.chooseUserTypeScreenRoute,
                                    );
                                  },
                                  btnText: 'login',
                                ),
                                Gaps.vGap25,
                              ],
                            ),

                      BlocBuilder<AppSettingCubit, AppSettingState>(
                        builder: (context, state) {
                          if (state is AppSettingLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is AppSettingLoaded) {
                            final config = state.resp.data as AppConfigEntity?;
                            if (config == null) {
                              return const SizedBox.shrink();
                            }
                            return FadeInUp(
                              child: _buildAppInfoSection(config),
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

                      if (sessionState.status ==
                          SessionStatus.authenticated) ...[
                        Gaps.vGap8,
                        _buildDeleteAccountButton(),
                        Gaps.vGap24,
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return InkWell(
      onTap: _onDeleteAccountPressed,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.errorColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: colors.errorColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: colors.errorColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.delete_forever_outlined,
                color: colors.errorColor,
                size: 22.sp,
              ),
            ),
            Gaps.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'delete_account'.tr,
                    style: TextStyles.semiBold14(color: colors.errorColor),
                  ),
                  Gaps.vGap4,
                  Text(
                    'delete_account_confirm_message'.tr,
                    style: TextStyles.medium10(
                      color: colors.errorColor.withValues(alpha: 0.75),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              appLocalizations.isEnLocale
                  ? Icons.chevron_right_rounded
                  : Icons.chevron_left_rounded,
              color: colors.errorColor.withValues(alpha: 0.7),
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteAccountPressed() async {
    final confirmed = await Constants.showConfirmDialog(
      context: context,
      title: 'delete_account_confirm_title'.tr,
      content: 'delete_account_confirm_message'.tr,
      yesText: 'delete_account',
      noText: 'close',
      yesButtonColor: colors.errorColor,
    );

    if (confirmed != true || !mounted) return;

    context.read<DeleteUserAccountCubit>().deleteUserAccount();
  }

  Future<void> _clearSessionAndNavigate() async {
    if (!mounted) return;
    try {
      await sessionCubit.logout(noLogoutApi: true);
    } catch (e, st) {
      debugPrint('Clear session after delete account error: $e\n$st');
    }
    if (!mounted) return;
    context.go(Routes.initialRoute);
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

  Widget _buildAppInfoSection(AppConfigEntity config) {
    final links = config.externalLinks ?? [];
    final registrationNumber = config.business?.commercialRegistrationNumber;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Gaps.vGap8,
          Image.asset(
            "assets/images/logo_horizontal.png",
            fit: BoxFit.scaleDown,
            width: 300.w,
            height: 80.h,
          ),

          Gaps.vGap10,
          if (links.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.center,
              children: links
                  .map(
                    (link) => _socialIcon(
                      FaIcon(_iconForLink(link.icon ?? link.name)),
                      link.url,
                      onTap: () {
                        if (link.url != null && link.url!.isNotEmpty) {
                          Constants.launchURL(link.url!);
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          if (registrationNumber != null && registrationNumber.isNotEmpty) ...[
            Gaps.vGap10,
            Text(
              '${'commercial_registration'.tr}: $registrationNumber',
              style: TextStyles.semiBold14(color: colors.lightTextColor),
              textAlign: TextAlign.center,
            ),
          ],
          Gaps.vGap10,
          Text(
            'all_rights_reserved'.tr,
            style: TextStyles.semiBold14(color: colors.lightTextColor),
          ),
          Gaps.vGap16,
        ],
      ),
    );
  }

  FaIconData _iconForLink(String? key) {
    switch (key?.toLowerCase()) {
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'tiktok':
        return FontAwesomeIcons.tiktok;
      case 'twitter':
      case 'x':
        return FontAwesomeIcons.xTwitter;
      case 'whatsapp':
        return FontAwesomeIcons.whatsapp;
      case 'snapchat':
        return FontAwesomeIcons.snapchat;
      case 'youtube':
        return FontAwesomeIcons.youtube;
      case 'linkedin':
        return FontAwesomeIcons.linkedin;
      default:
        return FontAwesomeIcons.link;
    }
  }

  Widget _socialIcon(
    FaIcon icon,
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
          child: icon,
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    if (!mounted) return;
    Constants.showLoading(context);
    try {
      await sessionCubit.logout();
    } catch (e, st) {
      debugPrint('Logout error: $e\n$st');
      if (mounted) {
        Constants.showSnakToast(
          context: context,
          type: 3,
          message: e.toString(),
        );
      }
    } finally {
      if (mounted) Constants.hideLoading(context);
    }
    if (!mounted) return;
    context.go(Routes.initialRoute);
  }
}
