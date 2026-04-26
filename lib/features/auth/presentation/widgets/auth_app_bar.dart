import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AuthAppBar extends StatelessWidget {
  final bool showBackButton;
  const AuthAppBar({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final bool isAr = appLocalizations.isArLocale;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Image.asset(ImageAssets.logo, height: 80.h, width: 106.w),
        if (showBackButton)
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.lightTextColor.withValues(alpha: .2),
                  width: 1.5.w,
                ),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                isAr ? SvgAssets.appBarArrowBack : SvgAssets.appBarArrowForward,
              ),
            ),
          ),
      ],
    );
  }
}
