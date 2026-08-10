import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/values/assets.dart';

class PhoneEntryScreen extends StatelessWidget {
  const PhoneEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.whiteColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImgAssets.logo, height: 180.h),
              Gaps.vGap50,
              Text(
                'enter_phone'.tr,
                style: TextStyles.bold16(color: colors.textColor),
              ),
              Gaps.vGap16,
              Text(
                'phone_subtitle'.tr,
                style: TextStyles.semiBold14(
                  color: colors.lightTextColor.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.vGap30,
              MyDefaultButton(
                btnText: 'create_account_btn',
                onPressed: () => context.pushNamed(Routes.registerRoute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
