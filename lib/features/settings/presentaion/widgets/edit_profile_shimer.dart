import 'package:alhakim/core/widgets/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class EditProfileShimmer extends StatelessWidget {
  const EditProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _header(),
                Gaps.vGap24,
                _avatar(),
                Gaps.vGap30,
                _textField(),
                _textField(),
                _textField(),
                _textField(),
                Gaps.vGap30,
                _button(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ================= Skeleton Parts =================

  Widget _header() {
    return Row(
      children: [
        _box(width: 40.w, height: 40.w, radius: 12),
        Gaps.hGap12,
        _box(width: 120.w, height: 20.h),
      ],
    );
  }

  Widget _avatar() {
    return Center(
      child: _box(width: 110.r, height: 110.r, radius: 55.r),
    );
  }

  Widget _textField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(width: 80.w, height: 14.h),
          Gaps.vGap8,
          _box(width: double.infinity, height: 48.h, radius: 12),
        ],
      ),
    );
  }

  Widget _button() {
    return _box(width: double.infinity, height: 50.h, radius: 14);
  }

  Widget _box({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
