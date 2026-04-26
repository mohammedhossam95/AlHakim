import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoDataFound extends StatelessWidget {
  final String text;
  const NoDataFound({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElasticIn(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(SvgAssets.aboutAppIcon),
            Gaps.vGap12,
            Text(text, style: TextStyles.bold16()),
          ],
        ),
      ),
    );
  }
}
