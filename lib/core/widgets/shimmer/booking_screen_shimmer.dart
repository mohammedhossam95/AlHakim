import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BookingScreenShimmer extends StatelessWidget {
  const BookingScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColorShimmer,
      highlightColor: highlightColorShimmer,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Row(
                children: [
                  _box(width: 75.w, height: 75.w, radius: 37.5.r),
                  Gaps.hGap16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(width: 140.w, height: 16.h, radius: 8.r),
                        Gaps.vGap8,
                        _box(width: 100.w, height: 14.h, radius: 8.r),
                        Gaps.vGap10,
                        _box(width: 60.w, height: 12.h, radius: 8.r),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gaps.vGap24,
            _box(width: 180.w, height: 18.h, radius: 8.r),
            Gaps.vGap8,
            _box(width: double.infinity, height: 14.h, radius: 8.r),
            Gaps.vGap20,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: index == 4 ? 0 : 12.w,
                    ),
                    child: _box(width: 72.w, height: 90.h, radius: 22.r),
                  );
                }),
              ),
            ),
            Gaps.vGap20,
            _box(width: double.infinity, height: 160.h, radius: 20.r),
            Gaps.vGap24,
            _box(width: double.infinity, height: 52.h, radius: 30.r),
          ],
        ),
      ),
    );
  }

  Widget _box({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
