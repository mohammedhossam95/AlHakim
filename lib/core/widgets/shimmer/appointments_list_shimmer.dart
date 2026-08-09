import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentsListShimmer extends StatelessWidget {
  const AppointmentsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColorShimmer,
      highlightColor: highlightColorShimmer,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        itemCount: 4,
        separatorBuilder: (_, _) => Gaps.vGap12,
        itemBuilder: (_, _) {
          return Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: colors.whiteColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gaps.hGap12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14.h,
                            width: 140.w,
                            decoration: BoxDecoration(
                              color: colors.whiteColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          Gaps.vGap8,
                          Container(
                            height: 12.h,
                            width: 90.w,
                            decoration: BoxDecoration(
                              color: colors.whiteColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 24.h,
                      width: 64.w,
                      decoration: BoxDecoration(
                        color: colors.whiteColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ],
                ),
                Gaps.vGap12,
                Container(
                  height: 12.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                Gaps.vGap10,
                Container(
                  height: 12.h,
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                Gaps.vGap12,
                Row(
                  children: [
                    Expanded(
                      child: Container( 
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: colors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    Gaps.hGap8,
                    Expanded(
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: colors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
