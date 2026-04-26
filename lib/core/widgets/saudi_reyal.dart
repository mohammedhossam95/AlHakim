import 'package:alhakim/core/utils/app_strings.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';

// class SaudiReyal extends StatelessWidget {
//   const SaudiReyal({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       AppStrings.saudiCurrency, // This should be "ريال" or "SAR"
//       style: TextStyle(
//         fontSize: 12.sp,
//         color: Colors.black,
//         fontWeight: FontWeight.w400,
//         fontFamily: "rayal", // Use your Arabic font if available
//       ),
//     );
//   }
// }

class SaudiCurrency extends StatelessWidget {
  const SaudiCurrency({
    super.key,
    this.text,
    this.textStyle,

    this.currencySize,
    this.currencyColor,
    this.fontWeightOfCurrency,
    this.isOldPrice = false,
  });
  final String? text;
  final Color? currencyColor;
  final double? currencySize;
  final TextStyle? textStyle;
  final FontWeight? fontWeightOfCurrency;
  final bool isOldPrice;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appLocalizations.isArLocale
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: textStyle?.copyWith(
                decoration: isOldPrice ? TextDecoration.lineThrough : null,
              ),
            ),

            TextSpan(text: ' '),

            TextSpan(
              text: AppStrings.saudiCurrency,
              style: TextStyle(
                fontFamily: "rayal",
                fontWeight: fontWeightOfCurrency ?? FontWeight.normal,
                fontSize: currencySize,
                color: currencyColor,
                decoration: isOldPrice ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
