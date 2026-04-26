import 'package:flutter/material.dart';

class MyColors {
  static const Color backGround = Color(0xFFECECEC);
  static const Color main = Color(0xFF005FB8);
  static const Color secondary = Color(0xFF00897B);
  static const Color textColor = Color(0xFF000000);
  static const Color lightTextColor = Color(0xFF565656);
  static const Color lightBackGroundColor = Color(0xFFfafafa);
  static const Color errorColor = Color(0xFFEF0F0F);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  /// 🔥 new semantic colors
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.yellow;

  // shared
  static const Color review = Color(0xffFFA534);
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color backGround;
  final Color main;
  final Color secondary;
  final Color textColor;
  final Color whiteColor;
  final Color errorColor;
  final Color review;
  final Color lightTextColor;
  final Color lightBackGroundColor;

  /// 🔥 new colors
  final Color success;
  final Color error;
  final Color warning;

  const AppColors({
    required this.backGround,
    required this.main,
    required this.secondary,
    required this.textColor,
    required this.whiteColor,
    required this.errorColor,
    required this.review,
    required this.lightTextColor,
    required this.lightBackGroundColor,
    required this.success,
    required this.error,
    required this.warning,
  });

  @override
  AppColors copyWith({
    Color? backGround,
    Color? main,
    Color? secondary,
    Color? textColor,
    Color? whiteColor,
    Color? errorColor,
    Color? review,
    Color? lightTextColor,
    Color? lightBackGroundColor,
    Color? success,
    Color? error,
    Color? warning,
  }) {
    return AppColors(
      backGround: backGround ?? this.backGround,
      main: main ?? this.main,
      secondary: secondary ?? this.secondary,
      textColor: textColor ?? this.textColor,
      whiteColor: whiteColor ?? this.whiteColor,
      errorColor: errorColor ?? this.errorColor,
      review: review ?? this.review,
      lightTextColor: lightTextColor ?? this.lightTextColor,
      lightBackGroundColor:
          lightBackGroundColor ?? this.lightBackGroundColor,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors> other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      backGround:
          Color.lerp(backGround, other.backGround, t) ?? backGround,
      main: Color.lerp(main, other.main, t) ?? main,
      secondary:
          Color.lerp(secondary, other.secondary, t) ?? secondary,
      textColor:
          Color.lerp(textColor, other.textColor, t) ?? textColor,
      whiteColor:
          Color.lerp(whiteColor, other.whiteColor, t) ?? whiteColor,
      errorColor:
          Color.lerp(errorColor, other.errorColor, t) ?? errorColor,
      review: Color.lerp(review, other.review, t) ?? review,
      lightTextColor: Color.lerp(
              lightTextColor, other.lightTextColor, t) ??
          lightTextColor,
      lightBackGroundColor: Color.lerp(
              lightBackGroundColor,
              other.lightBackGroundColor,
              t) ??
          lightBackGroundColor,

      /// 🔥 new colors
      success: Color.lerp(success, other.success, t) ?? success,
      error: Color.lerp(error, other.error, t) ?? error,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
    );
  }
}