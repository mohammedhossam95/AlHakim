import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/core/widgets/no_data_found.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const ErrorView({super.key,  this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NoDataFound(text: 'noData'.tr),
              Gaps.vGap20,
              MyDefaultButton(
                width: 200.w,
                height: 40.h,
                btnText: 'retry',
                onPressed: onRetry,
                textStyle: TextStyles.semiBold14(color: colors.whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
