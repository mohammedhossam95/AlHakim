import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/extension.dart';
import '../../injection_container.dart';

class LoadingView extends StatelessWidget {
  final Color? bgColor;
  final Color? loadingColor;
  final double? height;
  final double? width;

  const LoadingView({
    super.key,
    this.height,
    this.width,
    this.bgColor,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.sizeOf(context).width;
    return DottedBorder(
      options: CustomPathDottedBorderOptions(
        dashPattern: [10, 5],
        strokeWidth: 1,
        padding: EdgeInsets.all(4.r),
        color: colors.main,
        customPath: (size) {
          return Path()..addRRect(
            RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(30.r)),
          );
        },
      ),
      child: Container(
        width: width ?? screenWidth,
        height: (height ?? 48.0).h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: colors.textColor),
          color: bgColor ?? colors.main,
        ),
        child: Center(
          child: CircularProgressIndicator(
            padding: EdgeInsets.all(8.w),
            color: loadingColor ?? colors.whiteColor,
          ).appLoading,
        ),
      ),
    );
  }
}
