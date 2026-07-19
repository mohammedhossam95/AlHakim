import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class FollowUpQueueShimmer extends StatelessWidget {
  const FollowUpQueueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColorShimmer,
      highlightColor: highlightColorShimmer,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _box(height: 150.h, radius: 15.r),
            Gaps.vGap16,
            _box(height: 70.h, radius: 16.r),
            Gaps.vGap16,
            Row(
              children: [
                Expanded(child: _box(height: 120.h, radius: 16.r)),
                Gaps.hGap12,
                Expanded(child: _box(height: 120.h, radius: 16.r)),
              ],
            ),
            Gaps.vGap24,
            _box(height: 52.h, radius: 30.r),
          ],
        ),
      ),
    );
  }

  Widget _box({required double height, required double radius}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
