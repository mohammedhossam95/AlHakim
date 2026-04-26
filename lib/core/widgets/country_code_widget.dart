import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../injection_container.dart';

class CountryCodeWidget extends StatefulWidget {
  final Country? country;
  final ValueChanged<Country> updateValue;

  const CountryCodeWidget({super.key, required this.updateValue, this.country});

  @override
  State<CountryCodeWidget> createState() => _CountryCodeWidgetState();
}

class _CountryCodeWidgetState extends State<CountryCodeWidget> {
  Country? selcCountry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showCountryPicker(
        countryListTheme: CountryListThemeData(
          bottomSheetHeight: ScreenUtil().screenHeight * 0.6,
        ),
        context: context,
        favorite: <String>['EG', 'SA'],
        showPhoneCode: true,
        onSelect: (Country country) {
          setState(() {
            selcCountry = country;
            widget.updateValue(country);
          });
        },
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: colors.main.withValues(alpha: .1)),
          borderRadius: BorderRadius.circular(12.r),
          color:    colors.main.withValues(alpha: 0.1),
          //
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(selcCountry?.flagEmoji ?? widget.country?.flagEmoji ?? ''),
            SizedBox(width: 8.w),
            Text(selcCountry?.phoneCode ?? widget.country?.phoneCode ?? ''),
          ],
        ),
      ),
    );
  }
}
