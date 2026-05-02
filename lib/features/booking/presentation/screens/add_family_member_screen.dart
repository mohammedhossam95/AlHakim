import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  String? relation;

  final relations = ["ابن", "ابنة", "زوجة", "أب", "أم"];

  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: colors.backGround,
      appBar: AppBar(title: Text("add_family_member".tr)),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// name
            _Label("full_name".tr),
            Gaps.vGap8,
            MyTextFormField(
              controller: _nameController,
              hintText: "enter_name".tr,
            ),

            Gaps.vGap16,

            /// birthdate
            _Label("birth_date".tr),
            Gaps.vGap8,
            MyTextFormField(
              controller: _birthDateController,
              hintText: "birth_date_hint".tr,
              readOnly: true,
              prefixIcon: Icon(Icons.calendar_today, color: colors.main),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );

                if (picked != null) {
                  _birthDateController.text =
                      "${picked.day}/${picked.month}/${picked.year}";
                }
              },
            ),

            Gaps.vGap16,

            /// relation
            _Label("relation".tr),
            Gaps.vGap8,
            DropdownButtonFormField<String>(
              initialValue: relation,
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.medical_services, color: colors.main),
                filled: true,
                fillColor: colors.main.withValues(alpha: 0.05),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
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
              ),
              hint: Text("relation".tr, style: TextStyles.medium12()),
              items: relations
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => relation = val),
            ),

            Gaps.vGap30,

            /// button
            MyDefaultButton(onPressed: () {}, btnText: "add"),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.medium14(color: colors.textColor));
  }
}
