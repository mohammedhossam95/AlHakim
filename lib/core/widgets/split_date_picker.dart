import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplitDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int firstYear;
  final int? lastYear;

  const SplitDatePicker({
    super.key,
    required this.controller,
    this.validator,
    this.firstYear = 1900,
    this.lastYear,
  });

  @override
  State<SplitDatePicker> createState() => _SplitDatePickerState();
}

class _SplitDatePickerState extends State<SplitDatePicker> {
  int? selectedMonth;
  int? selectedDay;
  int? selectedYear;

  List<int> get years {
    final currentYear = widget.lastYear ?? DateTime.now().year;
    return List.generate(
      currentYear - widget.firstYear + 1,
      (i) => currentYear - i,
    );
  }

  List<int> get daysInSelectedMonth {
    if (selectedMonth == null || selectedYear == null) {
      return List.generate(31, (i) => i + 1);
    }
    final daysCount = DateTime(selectedYear!, selectedMonth! + 1, 0).day;
    return List.generate(daysCount, (i) => i + 1);
  }

  @override
  void initState() {
    super.initState();
    _parseDate(widget.controller.text);
  }

  void _parseDate(String? date) {
    if (date == null || date.isEmpty) return;
    final parts = date.split('-');
    if (parts.length != 3) return;

    selectedYear = int.tryParse(parts[0]);
    selectedMonth = int.tryParse(parts[1]);
    selectedDay = int.tryParse(parts[2]);
  }

  void _updateDate() {
    if (selectedYear == null || selectedMonth == null || selectedDay == null) {
      widget.controller.clear();
      return;
    }

    final maxDay = DateTime(selectedYear!, selectedMonth! + 1, 0).day;
    if (selectedDay! > maxDay) {
      selectedDay = maxDay;
    }

    widget.controller.text =
        "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}-${selectedDay.toString().padLeft(2, '0')}";
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      hintText: label,
      hintStyle: TextStyles.semiBold12(color: colors.lightTextColor),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: colors.main.withValues(alpha: .1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: colors.main),
      ),
    );
  }

  String? _validateDate(int? _) {
    if (widget.validator != null) {
      return widget.validator!(widget.controller.text);
    }
    if (selectedMonth == null || selectedDay == null || selectedYear == null) {
      return 'select_birth_date'.tr;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            initialValue: selectedMonth,
            isExpanded: true,
            decoration: _dropdownDecoration('month'.tr),
            icon: Icon(Icons.keyboard_arrow_down, color: colors.lightTextColor),
            validator: _validateDate,
            items: List.generate(12, (i) => i + 1)
                .map(
                  (m) => DropdownMenuItem(
                    value: m,
                    child: Text(
                      m.toString().padLeft(2, '0'),
                      style: TextStyles.medium14(),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedMonth = value;
                _updateDate();
              });
            },
          ),
        ),
        Gaps.hGap8,
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<int>(
            key: ValueKey('day_${selectedYear}_${selectedMonth}_$selectedDay'),
            initialValue:
                selectedDay != null && daysInSelectedMonth.contains(selectedDay)
                ? selectedDay
                : null,
            isExpanded: true,
            decoration: _dropdownDecoration('day'.tr),
            icon: Icon(Icons.keyboard_arrow_down, color: colors.lightTextColor),
            validator: _validateDate,
            items: daysInSelectedMonth
                .map(
                  (d) => DropdownMenuItem(
                    value: d,
                    child: Text(
                      d.toString().padLeft(2, '0'),
                      style: TextStyles.medium14(),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedDay = value;
                _updateDate();
              });
            },
          ),
        ),
        Gaps.hGap8,
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            initialValue: selectedYear,
            isExpanded: true,
            decoration: _dropdownDecoration('year'.tr),
            icon: Icon(Icons.keyboard_arrow_down, color: colors.lightTextColor),
            validator: _validateDate,
            items: years
                .map(
                  (y) => DropdownMenuItem(
                    value: y,
                    child: Text(y.toString(), style: TextStyles.medium14()),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedYear = value;
                _updateDate();
              });
            },
          ),
        ),
      ],
    );
  }
}
