import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '/core/utils/constants.dart';
import '/core/utils/values/svg_manager.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

class DiffImage extends StatelessWidget {
  final dynamic image;
  final dynamic height;
  final dynamic width;
  final dynamic onClick;
  final dynamic fitType;
  final dynamic radius;
  final bool isExpand;
  final bool hasBorder;
  final bool hasShadow;
  final Function? onUserTap;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final String? userName;
  final Color? userNameColor;
  final EdgeInsetsGeometry? padding;

  const DiffImage({
    super.key,
    this.image,
    this.height,
    this.width,
    this.radius = 5.0,
    this.isExpand = true,
    this.onClick = true,
    this.hasBorder = false,
    this.onUserTap,
    this.fitType = BoxFit.fill,
    this.hasShadow = false,
    this.borderRadius,
    this.isCircle = false,
    this.userName,
    this.userNameColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final double safeRadius = (radius is num)
        ? (radius as num).toDouble()
        : 5.0;
    final double? safeWidth = (width is num) ? (width as num).toDouble() : null;
    final double? safeHeight = (height is num)
        ? (height as num).toDouble()
        : null;

    return Container(
      width: safeWidth,
      height: safeHeight,
      padding: hasBorder ? padding ?? EdgeInsets.all(2.w) : null,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(safeRadius),
        border: hasBorder ? Border.all(color: colors.main) : null,
        boxShadow: hasShadow == true
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  blurRadius: 8.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 2.0),
                ),
              ]
            : [],
      ),
      child: image is String && image.toString().isNotEmpty
          ? ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(safeRadius),
              child: image.toString().startsWith('http')
                  ? CachedNetworkImage(
                      placeholder: (context, url) => const SizedBox(),
                      imageUrl: image.toString(),
                      fit: fitType is BoxFit ? fitType : BoxFit.fill,
                      memCacheHeight: 320.cacheSize(context),
                      memCacheWidth: 250.cacheSize(context),
                      errorWidget: (context, url, error) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(safeRadius),
                            border: Border.all(color: colors.textColor),
                          ),
                          child: SvgPicture.asset(SvgAssets.notFoundImage),
                        ),
                      ),
                    )
                  : Image.asset(
                      image.toString(),
                      fit: fitType is BoxFit ? fitType : BoxFit.fill,
                    ),
            )
          : ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(safeRadius),
              child: Container(
                decoration: isCircle
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        color: (userName == null || userName!.trim().isEmpty)
                            ? null
                            : userNameColor ?? colors.main,
                      )
                    : null,
                padding: EdgeInsets.all(
                  (safeWidth != null && safeWidth != double.infinity)
                      ? safeWidth * 0.2
                      : 10.r,
                ),
                width: safeWidth != null ? safeWidth * 0.6 : null,
                height: safeHeight != null ? safeHeight * 0.6 : null,
                color: isCircle
                    ? null
                    : (userName == null || userName!.trim().isEmpty)
                    ? null
                    : userNameColor ?? colors.main,
                child: (userName == null || userName!.trim().isEmpty)
                    ? SvgPicture.asset(SvgAssets.notFoundImage)
                    : Center(
                        child: Text(
                          Constants.getInitials(userName ?? ''),
                          style: TextStyles.bold16(
                            color: userNameColor == null
                                ? Colors.white
                                : colors.main,
                          ),
                        ),
                      ),
              ),
            ),
    );
  }
}

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}
