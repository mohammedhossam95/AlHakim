import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorActionButton extends StatelessWidget {
  final String svgAsset;
  final String label;
  final VoidCallback onTap;

  const DoctorActionButton({
    super.key,
    required this.svgAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 22.w,
              height: 22.w,
              colorFilter: ColorFilter.mode(colors.main, BlendMode.srcIn),
            ),
            Gaps.vGap4,
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.medium12(color: colors.lightTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
