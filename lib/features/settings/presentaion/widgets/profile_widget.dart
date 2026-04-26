// ignore_for_file: deprecated_member_use

import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfileWidet extends StatelessWidget {
  final String title, icon;
  final VoidCallback? onTap;
  const ProfileWidet({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAr = appLocalizations.isArLocale;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: colors.main,
              width: 24.w,
              height: 24.h,
            ),
            Gaps.hGap12,
            Text(title, style: TextStyles.regular14()),
            Spacer(),
            SvgPicture.asset(
              isAr ? SvgAssets.appBarArrowBack : SvgAssets.appBarArrowForward,
            ),
          ],
        ),
      ),
    );
  }
}
