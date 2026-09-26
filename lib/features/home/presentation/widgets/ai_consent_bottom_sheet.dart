import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/home/presentation/cubit/ai_consent_cubit/ai_consent_cubit.dart';
import 'package:alhakim/features/home/presentation/cubit/ai_consent_cubit/ai_consent_state.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Future<void> showAiConsentBottomSheet({
  required BuildContext context,
  VoidCallback? onAccepted,
}) {
  final cubit = context.read<AiConsentCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: cubit,
        child: AiConsentBottomSheet(onAccepted: onAccepted),
      );
    },
  );
}

class AiConsentBottomSheet extends StatelessWidget {
  final VoidCallback? onAccepted;

  const AiConsentBottomSheet({super.key, this.onAccepted});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r),
              topRight: Radius.circular(25.r),
            ),
            color: colors.backGround,
          ),
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SafeArea(
            top: false,
            child: BlocConsumer<AiConsentCubit, AiConsentState>(
              listener: (context, state) {
                if (state is AiConsentGranted) {
                  Navigator.pop(context);
                  onAccepted?.call();
                } else if (state is AiConsentError) {
                  Constants.showSnakToast(
                    context: context,
                    type: 3,
                    message: state.message,
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is AiConsentLoading;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ai_consent_title'.tr,
                        style: TextStyles.bold18(color: colors.textColor),
                      ),
                      Gaps.vGap16,
                      Text(
                        'ai_consent_body'.tr,
                        style: TextStyles.regular14(
                          color: colors.textColor,
                        ).copyWith(height: 1.6),
                      ),
                      Gaps.vGap16,
                      Text(
                        'ai_consent_bullet_text_only'.tr,
                        style: TextStyles.regular14(
                          color: colors.textColor,
                        ).copyWith(height: 1.6),
                      ),
                      Gaps.vGap8,
                      Text(
                        'ai_consent_bullet_no_personal_data'.tr,
                        style: TextStyles.regular14(
                          color: colors.textColor,
                        ).copyWith(height: 1.6),
                      ),
                      Gaps.vGap8,
                      Text(
                        'ai_consent_bullet_symptoms_only'.tr,
                        style: TextStyles.regular14(
                          color: colors.textColor,
                        ).copyWith(height: 1.6),
                      ),
                      Gaps.vGap8,
                      Text(
                        'ai_consent_bullet_not_diagnosis'.tr,
                        style: TextStyles.regular14(
                          color: colors.textColor,
                        ).copyWith(height: 1.6),
                      ),
                      Gaps.vGap16,
                      InkWell(
                        onTap: isLoading
                            ? null
                            : () {
                                context.push(
                                  Routes.staticPageScreenRoute,
                                  extra: StaticPageType.privacy,
                                );
                              },
                        child: Text(
                          'privacy_policy'.tr,
                          style: TextStyles.semiBold14(color: colors.main)
                              .copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: colors.main,
                              ),
                        ),
                      ),
                      Gaps.vGap24,
                      MyDefaultButton(
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<AiConsentCubit>().accept();
                              },
                        btnText: 'ai_consent_accept',
                      ),
                      Gaps.vGap12,
                      MyDefaultButton(
                        withDottedBorder: false,
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        btnText: 'ai_consent_not_now',
                        color: colors.whiteColor,
                        borderColor: colors.main,
                        textColor: colors.main,
                        textStyle: TextStyles.medium14(color: colors.main),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
