import 'package:alhakim/core/utils/app_strings.dart';
import 'package:alhakim/core/utils/values/strings.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/utils/enums.dart';
import '/core/utils/values/assets.dart';
import '/core/widgets/my_default_button.dart';
import '../../injection_container.dart';
import '../utils/values/gif_manager.dart';

class ErrorText extends StatefulWidget {
  final String? text;

  final bool isNetwork;

  final double? height;

  final double width;

  final MyError search;

  final EdgeInsetsGeometry? margin;

  final VoidCallback? onRetry;

  const ErrorText({
    super.key,
    required this.width,
    this.text,
    this.isNetwork = false,
    this.height,
    this.search = MyError.defaultError,
    this.margin,
    this.onRetry,
  });

  @override
  State<ErrorText> createState() => _ErrorTextState();
}

class _ErrorTextState extends State<ErrorText> {
  @override
  Widget build(BuildContext context) {
    return widget.isNetwork
        ? Scaffold(
            body: SafeArea(child: _buildContainer(context, widget.width)),
          )
        : _buildContainer(context, widget.width);
  }

  Widget _buildContainer(BuildContext context, double width) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      margin: widget.margin ?? EdgeInsets.zero,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          /// image
          SizedBox(
            width: width * .65,
            height: width * .65,

            child: Image.asset(
              widget.isNetwork
                  ? ImgAssets.noData
                  : errorImage(widget.search, context),
            ),
          ),

          Gaps.vGap10,

          /// text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),

            child: AutoSizeText(
              widget.text == AppStrings.unAuthorizedFailure
                  ? Strings.welcomeToAppMessage
                  : "${widget.text}",

              textAlign: TextAlign.center,

              style: TextStyles.regular18(color: colors.errorColor),
            ),
          ),
          Gaps.vGap16,

          /// login button
          // if (widget.text == AppStrings.unAuthorizedFailure)
          //   Container(
          //     margin: EdgeInsets.all(20.r),

          //     child: MyDefaultButton(
          //       onPressed: () {
          //         context.go(Routes.loginScreenRoute);
          //       },

          //       btnText: Strings.login,

          //       localeText: true,
          //     ),
          //   ),

          // /// retry button
          if (widget.onRetry != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),

              child: MyDefaultButton(
                width: 200.w,
                height: 40.h,
                btnText: 'retry',
                onPressed: widget.onRetry!,
                textStyle: TextStyles.semiBold14(color: colors.whiteColor),
              ),
            ),
        ],
      ),
    );
  }

  String errorImage(MyError type, BuildContext context) {
    switch (type) {
      case MyError.saerch:
        return GifAssets.noUser;

      default:
        return ImgAssets.imagesNoData;
    }
  }
}
