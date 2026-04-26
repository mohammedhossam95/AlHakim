import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/widgets/diff_img.dart'; // Adjust path
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/home/domain/entity/slider_entity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart'; // Adjust path

class SliderPart extends StatefulWidget {
  const SliderPart({super.key, required this.list});
  final List<SliderEntity> list;

  @override
  State<SliderPart> createState() => _SliderPartState();
}

class _SliderPartState extends State<SliderPart> {
  int initIndex = 0;

  void _handleSliderNavigation(BuildContext context, SliderEntity slider) {
    if (slider.redirectType == null) return;

    switch (slider.redirectType) {
      case 'product':
        if (slider.redirectTypeId != null) {}
        break;

      case 'category':
        if (slider.redirectTypeId != null) {}
        break;

      default:
        debugPrint('Unknown redirect type: ${slider.redirectType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return Container(
        width: 1.sw,
        height: 150.h,
        color: Colors.grey.shade200,
        child: Center(child: Text('noـslidersـavailable'.tr)),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() => initIndex = index);
            },
            height: 150.h,
            viewportFraction: 0.82,
            autoPlay: true,
            enlargeCenterPage: true,
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
          items: widget.list.map((slider) {
            return InkWell(
              onTap: () => _handleSliderNavigation(context, slider),
              borderRadius: BorderRadius.circular(15.r),
              child: DiffImage(
                image: slider.image,
                fitType: BoxFit.fill,
                width: 1.sw,
                radius: 15.r,
              ),
            );
          }).toList(),
        ),
        Gaps.vGap12,
        _buildDots(),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.list.length, (index) {
        final bool isActive = index == initIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 6.h,
          width: isActive ? 18.w : 6.w,
          decoration: BoxDecoration(
            color: isActive ? colors.main : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.r),
          ),
        );
      }),
    );
  }
}
