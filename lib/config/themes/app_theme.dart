import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/values/app_colors.dart';
import '../../core/utils/values/fonts.dart';

ThemeData getAppTheme(BuildContext context) {
  return ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
        backGround: MyColors.backGround,
        whiteColor: MyColors.whiteColor,
        main: MyColors.main,
        secondary: MyColors.secondary,
        textColor: MyColors.textColor,
        errorColor: MyColors.errorColor,
        review: MyColors.review,
        lightTextColor: MyColors.lightTextColor,
        lightBackGroundColor: MyColors.lightBackGroundColor,
        success: MyColors.success,
        error: MyColors.error,
        warning: MyColors.warning,
      ),
    ],
    fontFamily: Fonts.primary,
    brightness: Brightness.light,
    primaryColor: MyColors.main,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: MyColors.main,
      error: MyColors.errorColor,
    ),
    dividerTheme: DividerThemeData(
      thickness: 1,
      indent: 4.w,
      endIndent: 4.w,
      color: Color(0xffF2F2F2),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all<Color>(MyColors.whiteColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MyColors.main,
    ),
    scaffoldBackgroundColor: MyColors.whiteColor,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: MyColors.whiteColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: MyColors.main,
      foregroundColor: MyColors.whiteColor,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: MyColors.whiteColor,
      titleSpacing: 35.w,
      toolbarHeight: 70.h,
      actionsIconTheme: IconThemeData(color: MyColors.textColor, size: 24.r),
      iconTheme: IconThemeData(color: MyColors.textColor, size: 24.r),
      titleTextStyle: TextStyle(
        fontFamily: Fonts.primary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: MyColors.textColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MyColors.whiteColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: Fonts.primary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: MyColors.textColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: Fonts.primary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: MyColors.textColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(padding: EdgeInsets.zero),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      },
    ),
    useMaterial3: false,
  );
}
