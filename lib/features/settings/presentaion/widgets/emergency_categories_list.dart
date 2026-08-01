import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/features/settings/domain/entity/emergency_category_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyCategoriesList extends StatelessWidget {
  final List<EmergencyCategoryEntity> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategorySelected;

  const EmergencyCategoriesList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  bool get _isAllSelected => selectedCategoryId == null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CategoryChip(
              label: 'all'.tr,
              isSelected: _isAllSelected,
              onTap: () => onCategorySelected(null),
            );
          }

          final category = categories[index - 1];
          return _CategoryChip(
            label: category.name ?? '',
            isSelected: selectedCategoryId == category.id,
            onTap: () => onCategorySelected(category.id),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? colors.main : colors.whiteColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? colors.main
                : colors.main.withValues(alpha: 0.52),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyles.medium14(
            color: isSelected ? colors.whiteColor : colors.textColor,
          ),
        ),
      ),
    );
  }
}
