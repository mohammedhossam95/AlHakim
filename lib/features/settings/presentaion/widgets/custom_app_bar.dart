import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool isInTabBar;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.isInTabBar,
  });

  @override
  Widget build(BuildContext context) {
    //final bool isAr = appLocalizations.isArLocale;
    return Row(
      children: [
        isInTabBar ? SizedBox() : CustomBackButton(),
        isInTabBar ? Gaps.hGap12 : Gaps.hGap16,

        Text(title, style: TextStyles.bold16()),
      ],
    );
  }
}
