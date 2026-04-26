import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/widgets/gaps.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../injection_container.dart';

class CountryCodeWidget extends StatefulWidget {
  final Country? country;
  final ValueChanged<Country>? updateValue;
  final bool canTap;

  const CountryCodeWidget({
    super.key,
    this.updateValue,
    this.country,
    this.canTap = true,
  });

  @override
  State<CountryCodeWidget> createState() => _CountryCodeWidgetState();
}

class _CountryCodeWidgetState extends State<CountryCodeWidget> {
  Country? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.canTap) {
          showCountryPicker(
            context: context,
            favorite: <String>['EG', 'SA'],
            showPhoneCode: true,
            countryListTheme: CountryListThemeData(
              bottomSheetHeight: ScreenUtil().screenHeight * 0.6,
            ),
            onSelect: (Country country) {
              setState(() {
                selectedCountry = country;
                widget.updateValue?.call(country);
              });
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 18.h),
        decoration: BoxDecoration(
            color: colors.backGround,
            border: Border.all(color: colors.textColor),
            borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          children: [
            Text(
              '${selectedCountry?.flagEmoji ?? widget.country?.flagEmoji ?? ''} +${selectedCountry?.phoneCode ?? widget.country?.phoneCode ?? ''}',
              style: TextStyles.medium12(color: colors.textColor),
              textDirection: TextDirection.rtl,
            ),
            Gaps.hGap4,
            Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}

class AmrCountryCodeWidget extends StatefulWidget {
  final Country? country;
  final ValueChanged<Country>? updateValue;
  final bool canTap;
  final bool showFlag;

  const AmrCountryCodeWidget({
    super.key,
    this.updateValue,
    this.country,
    this.canTap = true,
    required this.showFlag,
  });

  @override
  State<AmrCountryCodeWidget> createState() => _AmrCountryCodeWidgetState();
}

class _AmrCountryCodeWidgetState extends State<AmrCountryCodeWidget> {
  Country? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.canTap) {
          showCountryPicker(
            context: context,
            favorite: <String>['EG', 'SA'],
            showPhoneCode: true,
            onSelect: (Country country) {
              setState(() {
                selectedCountry = country;
                widget.updateValue?.call(country);
              });
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Text(
              '${widget.showFlag ? selectedCountry?.flagEmoji ?? widget.country?.flagEmoji ?? '' : ''} +${selectedCountry?.phoneCode ?? widget.country?.phoneCode ?? ''}',
              style: TextStyles.medium12(),
              textDirection: TextDirection.rtl,
            ),
            Gaps.hGap10,
            Container(
              height: 18.h,
              width: 1.w,
              color: colors.textColor,
            ),
          ],
        ),
      ),
    );
  }
}
