import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HospitalEmergencyShimmer extends StatelessWidget {
  const HospitalEmergencyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColorShimmer,
      highlightColor: highlightColorShimmer,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        itemCount: 3,
        separatorBuilder: (_, _) => Gaps.vGap16,
        itemBuilder: (_, _) {
          return Container(
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _line(width: 180.w, height: 16.h),
                                Gaps.vGap8,
                                _line(width: 140.w, height: 12.h),
                              ],
                            ),
                          ),
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: colors.whiteColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      Gaps.vGap12,
                      _line(width: double.infinity, height: 12.h),
                      Gaps.vGap8,
                      _line(width: 220.w, height: 12.h),
                      Gaps.vGap12,
                      Row(
                        children: [
                          _chip(),
                          Gaps.hGap8,
                          _chip(),
                          Gaps.hGap8,
                          _chip(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  Widget _chip() {
    return Container(
      width: 72.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
}
