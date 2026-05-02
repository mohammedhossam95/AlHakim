// ignore_for_file: deprecated_member_use

import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserTypeCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final UserType userType;
  final bool isSelected;
  final bool isProminent;
  final VoidCallback onTap;

  const UserTypeCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.userType,
    this.isSelected = false,
    this.isProminent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: isProminent ? double.infinity : null,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.main.withValues(alpha: 0.15)
              : colors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected
              ? Border.all(color: colors.main, width: 1.w)
              : Border.all(
                  color: colors.textColor.withValues(alpha: 0.2),
                  width: 1.w,
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyles.semiBold18(
                color: isSelected ? colors.main : colors.textColor,
              ),
            ),
            Gaps.vGap10,
            Text(
              textAlign: TextAlign.center,
              description,
              style: TextStyles.medium12(
                color: isSelected
                    ? colors.main.withValues(alpha: 0.8)
                    : colors.textColor.withValues(alpha: 0.7),
              ).copyWith(height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
