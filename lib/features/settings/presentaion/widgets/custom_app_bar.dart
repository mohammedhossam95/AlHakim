import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool isInTabBar;
  final Color? titleColor;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.isInTabBar,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isInTabBar ? const SizedBox() : const CustomBackButton(),
        isInTabBar ? Gaps.hGap12 : Gaps.hGap16,
        Text(
          title,
          style: TextStyles.bold16(
            color: titleColor ?? colors.textColor,
          ),
        ),
      ],
    );
  }
}
