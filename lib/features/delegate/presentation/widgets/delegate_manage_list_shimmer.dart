import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DelegateManageListShimmer extends StatelessWidget {
  final int itemCount;

  const DelegateManageListShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: itemCount,
      separatorBuilder: (_, _) => Gaps.vGap18,
      itemBuilder: (_, _) {
        return Shimmer.fromColors(
          baseColor: baseColorShimmer,
          highlightColor: highlightColorShimmer,
          child: Container(
            height: 180.h,
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
    );
  }
}
