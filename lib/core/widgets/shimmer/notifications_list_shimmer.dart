import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsListShimmer extends StatelessWidget {
  const NotificationsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColorShimmer,
      highlightColor: highlightColorShimmer,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, _) => Gaps.vGap8,
        itemBuilder: (_, _) {
          return Container(
            height: 84.h,
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
          );
        },
      ),
    );
  }
}
