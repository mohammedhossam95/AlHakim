import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '/core/utils/values/text_styles.dart';
import '../../config/locale/app_localizations.dart';
import '../../injection_container.dart';

enum ButtonIconType { svg, icon, image, none }

class MyDefaultButton extends StatelessWidget {
  final String? btnText;
  final bool localeText;
  final Function()? onPressed;
  final Color? color;
  final Color? textColor;
  final bool isSelected;
  final bool? isLoading;
  final double? height;
  final double? width;
  final String? svgAsset;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? borderColor;
  final bool withDottedBorder;
  final bool rightIcon;
  final ButtonIconType buttonIconType;
  final IconData? iconData;
  final String? imageAsset;
  final double iconSize;

  const MyDefaultButton({
    super.key,
    this.btnText,
    this.textStyle,
    this.isLoading,
    required this.onPressed,
    this.color,
    this.isSelected = true,
    this.localeText = false,
    this.textColor,
    this.height,
    this.width,
    this.svgAsset,
    this.borderRadius,
    this.borderColor,
    this.withDottedBorder = true,
    this.rightIcon = false,
    this.buttonIconType = ButtonIconType.none,
    this.iconData,
    this.imageAsset,
    this.iconSize = 24,
  });

  ButtonIconType get _resolvedIconType {
    if (buttonIconType != ButtonIconType.none) return buttonIconType;
    if (svgAsset != null) return ButtonIconType.svg;
    if (iconData != null) return ButtonIconType.icon;
    if (imageAsset != null) return ButtonIconType.image;
    return ButtonIconType.none;
  }

  Widget? _buildButtonIcon() {
    final Color iconColor = textColor ?? colors.whiteColor;
    switch (_resolvedIconType) {
      case ButtonIconType.svg:
        if (svgAsset == null) return null;
        return SvgPicture.asset(
          svgAsset!,
          height: iconSize.h,
          width: iconSize.w,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );
      case ButtonIconType.icon:
        if (iconData == null) return null;
        return Icon(iconData, size: iconSize.sp, color: iconColor);
      case ButtonIconType.image:
        if (imageAsset == null) return null;
        return Image.asset(
          imageAsset!,
          height: iconSize.h,
          width: iconSize.w,
          color: iconColor,
        );
      case ButtonIconType.none:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    AppLocalizations locale = AppLocalizations.of(context)!;
    final buttonIcon = _buildButtonIcon();

    return DottedBorder(
      options: withDottedBorder
          ? CustomPathDottedBorderOptions(
              dashPattern: [10, 5],
              strokeWidth: 1,
              padding: EdgeInsets.all(4.r),
              color: borderColor ?? colors.main,
              customPath: (size) {
                return Path()..addRRect(
                  RRect.fromRectAndRadius(
                    Offset.zero & size,
                    Radius.circular(30.r),
                  ),
                );
              },
            )
          : RectDottedBorderOptions(
              padding: EdgeInsets.zero,
              color: Colors.transparent,
            ),

      child: SizedBox(
        width: width ?? screenWidth,
        height: (height ?? 50.0).h,
        child: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : ElevatedButton(
                style: ButtonStyle(
                  mouseCursor: WidgetStateProperty.all<MouseCursor>(
                    SystemMouseCursors.click,
                  ),
                  alignment: Alignment.center,
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        borderRadius?.r ?? 30.r,
                      ),
                      side: BorderSide(color: borderColor ?? colors.main),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all<Color>(
                    color ?? colors.main,
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    textColor ?? colors.textColor,
                  ),
                ),
                onPressed: onPressed,
                child: buttonIcon == null
                    ? Text(
                        localeText ? btnText! : locale.text(btnText!),
                        textAlign: TextAlign.center,
                        style:
                            textStyle ??
                            TextStyles.medium16(
                              color: textColor ?? colors.whiteColor,
                            ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (rightIcon) ...[
                            buttonIcon,
                            const SizedBox(width: 6),
                          ],
                          Text(
                            localeText ? btnText! : locale.text(btnText!),
                            textAlign: TextAlign.center,
                            style:
                                textStyle ??
                                TextStyles.medium16(
                                  color: textColor ?? colors.whiteColor,
                                ),
                          ),
                          if (!rightIcon) ...[
                            const SizedBox(width: 6),
                            buttonIcon,
                          ],
                        ],
                      ),
              ),
      ),
    );
  }
}
