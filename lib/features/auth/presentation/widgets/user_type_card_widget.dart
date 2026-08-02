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
  final IconData icon;
  final VoidCallback onTap;

  const UserTypeCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.userType,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.main.withValues(alpha: 0.1)
              : colors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? colors.main
                : colors.lightTextColor.withValues(alpha: 0.25),
            width: 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colors.lightTextColor.withValues(alpha: 0.12),
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? colors.main : colors.lightTextColor,
                size: 24.sp,
              ),
            ),
            Gaps.vGap12,
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.semiBold16(
                color: isSelected ? colors.main : colors.textColor,
              ),
            ),
            Gaps.vGap8,
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyles.medium12(
                color: isSelected
                    ? colors.main.withValues(alpha: 0.8)
                    : colors.lightTextColor,
              ).copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
