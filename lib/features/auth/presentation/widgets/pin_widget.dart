import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../../../../core/utils/media_query_values.dart';
import '../../../../injection_container.dart';

class PinCodeWidget extends StatelessWidget {
  final Function(String) textSubmit;
  final TextEditingController? controller;
  final int? pinLength;
  final FocusNode? focus;
  final double? pinBoxWidth;

  const PinCodeWidget({
    super.key,
    this.controller,
    this.pinLength,
    this.focus,
    this.pinBoxWidth,
    required this.textSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PinCodeTextField(
        autofocus: false,
        highlight: true,
        focusNode: focus,
        controller: controller,
        maxLength: pinLength ?? 4,
        pinBoxHeight: MediaQueryValues(context).width * 0.16,
        pinBoxWidth: pinBoxWidth ?? MediaQueryValues(context).width * 0.14,
        pinBoxRadius: 8.0.r,
        pinBoxBorderWidth: 1.5,
        wrapAlignment: WrapAlignment.center,
        pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 300),
        keyboardType: TextInputType.number,
        pinTextStyle: TextStyles.bold18(color: colors.main),
        onTextChanged: (text) {},
        hasTextBorderColor: colors.main,
        defaultBorderColor: colors.main.withValues(alpha: 0.3),
        highlightColor: colors.main,
        pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
        onDone: (text) => textSubmit(text),
      ),
    );
  }
}
