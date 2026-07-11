import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DelegateManageItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool isActive;
  final String activeStatusText;
  final String inactiveStatusText;
  final String activeBadgeText;
  final String inactiveBadgeText;
  final String editLabel;
  final String toggleActiveLabel;
  final String toggleInactiveLabel;
  final String deleteLabel;
  final VoidCallback? onEdit;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final bool showActions;

  const DelegateManageItemCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.activeStatusText,
    required this.inactiveStatusText,
    required this.activeBadgeText,
    required this.inactiveBadgeText,
    required this.editLabel,
    required this.toggleActiveLabel,
    required this.toggleInactiveLabel,
    required this.deleteLabel,
    this.onEdit,
    this.onToggle,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.whiteColor, width: 1.5.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              DiffImage(
                image: image,
                width: 60.0.w,
                height: 60.0.h,
                userName: title,
                isCircle: true,
                fitType: BoxFit.cover,
                borderRadius: BorderRadius.circular(12.r),
              ),
              Gaps.hGap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.semiBold16(),
                      textAlign: TextAlign.right,
                    ),
                    Gaps.vGap8,
                    Text(
                      subtitle,
                      style: TextStyles.medium13(color: colors.lightTextColor),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.vGap8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: isActive ? colors.secondary : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Gaps.hGap6,
                        Text(
                          isActive ? activeStatusText : inactiveStatusText,
                          style: TextStyles.medium12(
                            color: isActive
                                ? colors.secondary
                                : colors.lightTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gaps.hGap12,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? colors.secondary.withValues(alpha: .15)
                      : Colors.grey.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  isActive ? activeBadgeText : inactiveBadgeText,
                  style: TextStyles.medium12(
                    color: isActive ? colors.secondary : colors.lightTextColor,
                  ),
                ),
              ),
            ],
          ),
          if (showActions &&
              (onEdit != null || onToggle != null || onDelete != null)) ...[
            Divider(),
            Row(
              children: [
                if (onEdit != null)
                  Expanded(
                    child: InkWell(
                      onTap: onEdit,
                      child: _ActionTile(
                        icon: Icons.edit_outlined,
                        label: editLabel,
                        iconColor: colors.main,
                        labelColor: colors.main,
                        borderColor: colors.backGround.withValues(alpha: .9),
                      ),
                    ),
                  ),
                if (onEdit != null && onToggle != null) Gaps.hGap12,
                if (onToggle != null)
                  Expanded(
                    child: InkWell(
                      onTap: onToggle,
                      child: _ActionTile(
                        icon: isActive
                            ? Icons.ac_unit_rounded
                            : Icons.play_arrow_rounded,
                        label: isActive
                            ? toggleActiveLabel
                            : toggleInactiveLabel,
                        iconColor: isActive ? Colors.orange : colors.whiteColor,
                        labelColor: isActive
                            ? Colors.orange
                            : colors.whiteColor,
                        backgroundColor: isActive
                            ? Colors.orange.withValues(alpha: .12)
                            : colors.main,
                      ),
                    ),
                  ),
                if (onToggle != null && onDelete != null) Gaps.hGap12,
                if (onDelete != null)
                  Expanded(
                    child: InkWell(
                      onTap: onDelete,
                      child: _ActionTile(
                        icon: Icons.cancel_outlined,
                        label: deleteLabel,
                        iconColor: colors.errorColor,
                        labelColor: colors.errorColor,
                        borderColor: colors.backGround.withValues(alpha: .9),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color labelColor;
  final Color? backgroundColor;
  final Color? borderColor;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.labelColor,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.r),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30.sp),
          Gaps.vGap4,
          Text(label, style: TextStyles.medium14(color: labelColor)),
        ],
      ),
    );
  }
}
