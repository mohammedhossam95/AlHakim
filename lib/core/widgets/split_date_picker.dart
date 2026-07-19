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

  InputDecoration get _dropdownDecoration {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
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

  Widget _fitText(String text, {TextStyle? style}) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        maxLines: 1,
        softWrap: false,
        style: style ?? TextStyles.medium12(color: colors.lightTextColor),
      ),
    );
  }

  Widget _buildDropdown({
    required Key? key,
    required int? value,
    required String hint,
    required List<int> values,
    required ValueChanged<int?> onChanged,
    String Function(int value)? labelBuilder,
  }) {
    String labelOf(int v) =>
        labelBuilder?.call(v) ?? v.toString().padLeft(2, '0');

    return DropdownButtonFormField<int>(
      key: key,
      initialValue: value != null && values.contains(value) ? value : null,
      isExpanded: true,
      isDense: true,
      decoration: _dropdownDecoration,
      iconSize: 18.sp,
      icon: Icon(Icons.keyboard_arrow_down, color: colors.lightTextColor),
      hint: _fitText(hint),
      validator: _validateDate,
      selectedItemBuilder: (context) {
        return values
            .map(
              (v) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: _fitText(labelOf(v), style: TextStyles.medium14()),
              ),
            )
            .toList();
      },
      items: values
          .map(
            (v) => DropdownMenuItem(
              value: v,
              child: Text(labelOf(v), style: TextStyles.medium14()),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDropdown(
            key: null,
            value: selectedMonth,
            hint: 'month'.tr,
            values: List.generate(12, (i) => i + 1),
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
          child: _buildDropdown(
            key: ValueKey('day_${selectedYear}_${selectedMonth}_$selectedDay'),
            value: selectedDay,
            hint: 'day'.tr,
            values: daysInSelectedMonth,
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
          child: _buildDropdown(
            key: null,
            value: selectedYear,
            hint: 'year'.tr,
            values: years,
            labelBuilder: (y) => y.toString(),
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
