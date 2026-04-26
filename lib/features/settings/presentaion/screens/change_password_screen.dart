import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/params/change_password_params.dart';
import '/core/widgets/app_snack_bar.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/features/settings/presentaion/cubit/change_password_cubit/change_password_cubit.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/tags_text_form_field.dart';
import '../../../../injection_container.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  FocusNode currentPasswordFocus = FocusNode();
  TextEditingController newPasswordController = TextEditingController();
  FocusNode newPasswordFocus = FocusNode();
  TextEditingController confirmNewPasswordController = TextEditingController();
  FocusNode confirmNewPasswordFocus = FocusNode();
  bool isSecured = true;
  bool isSecured1 = true;
  bool isSecured2 = true;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(
        backgroundColor: colors.backGround,
        title: Text(
          'changePassword'.tr,
          style: TextStyles.bold20(color: colors.textColor),
        ),
        elevation: 0,
        //  leading: CustomBack(),
      ),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccessState) {
            showAppSnackBar(
              context: context,
              type: ToastType.success,
              message: state.resp.message ?? '',
            );
          }
          if (state is ChangePasswordErrorState) {
            showAppSnackBar(
              context: context,
              type: ToastType.error,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Expanded(
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             'changePassword'.tr,
                    //             style: TextStyles.bold20(color: colors.main),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.pop(context);
                    //       },
                    //       child: Container(
                    //         height: 40.h,
                    //         width: 40.w,
                    //         margin: EdgeInsets.only(top: 20.h),
                    //         decoration: BoxDecoration(
                    //           color: colors.textColor.withValues(alpha: .3),
                    //           borderRadius: BorderRadius.circular(10.r),
                    //         ),
                    //         child: Icon(
                    //           Icons.arrow_forward_ios_rounded,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    //Gaps.vGap20,
                    // Center(
                    //   child: Image.asset(
                    //     ImgAssets.changePasswordImage,
                    //     width: ScreenUtil().screenWidth * 0.25,
                    //     height: ScreenUtil().screenWidth * 0.25,
                    //     color: colors.textColor,
                    //   ),
                    // ),
                    Gaps.vGap40,
                    Text(
                      'currentPassword'.tr,
                      style: TextStyles.bold14(color: colors.textColor),
                    ),
                    Gaps.vGap10,
                    AppTextFormField(
                      borderColor: colors.textColor.withValues(alpha: 240),
                      controller: currentPasswordController,
                      focusNode: currentPasswordFocus,
                      hintText: 'currentPassword'.tr,
                      obscureText: isSecured,
                      textInputAction: TextInputAction.next,
                      validatorType: ValidatorType.password,
                      suffixIcon: isSecured == true
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isSecured = !isSecured;
                                });
                              },
                              icon: Icon(Icons.visibility),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  isSecured = !isSecured;
                                });
                              },
                              icon: Icon(Icons.visibility_off),
                            ),
                    ),
                    Gaps.vGap11,
                    Text(
                      'newPassword'.tr,
                      style: TextStyles.bold14(color: colors.textColor),
                    ),
                    Gaps.vGap10,
                    AppTextFormField(
                      borderColor: colors.textColor.withValues(alpha: 240),

                      controller: newPasswordController,
                      focusNode: newPasswordFocus,
                      hintText: 'newPassword'.tr,
                      obscureText: isSecured1,
                      textInputAction: TextInputAction.next,
                      // validatorType: ValidatorType.password,
                      suffixIcon: isSecured1 == true
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isSecured1 = !isSecured1;
                                });
                              },
                              icon: Icon(Icons.visibility),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  isSecured1 = !isSecured1;
                                });
                              },
                              icon: Icon(Icons.visibility_off),
                            ),
                    ),
                    Gaps.vGap11,
                    Text(
                      'confirmNewPassword'.tr,
                      style: TextStyles.bold14(color: colors.textColor),
                    ),
                    Gaps.vGap10,
                    AppTextFormField(
                      borderColor: colors.textColor.withValues(alpha: 240),

                      controller: confirmNewPasswordController,
                      focusNode: confirmNewPasswordFocus,
                      hintText: 'confirmNewPassword'.tr,
                      obscureText: isSecured2,
                      textInputAction: TextInputAction.done,
                      // validatorType: ValidatorType.confirmPassword,
                      suffixIcon: isSecured2 == true
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isSecured2 = !isSecured2;
                                });
                              },
                              icon: Icon(Icons.visibility),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  isSecured2 = !isSecured2;
                                });
                              },
                              icon: Icon(Icons.visibility_off),
                            ),
                    ),
                    Gaps.vGap50,
                    (state is ChangePasswordLoadingState)
                        ? Center(child: const CircularProgressIndicator())
                        : MyDefaultButton(
                            onPressed: () async {
                              setState(() {});
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await context
                                    .read<ChangePasswordCubit>()
                                    .changePassword(
                                      ChangePasswordParams(
                                        currentPassword:
                                            currentPasswordController.text,
                                        newPassword: newPasswordController.text,
                                        newPasswordConfirmation:
                                            confirmNewPasswordController.text,
                                      ),
                                    );
                              }
                            },
                            btnText: 'saveChanges',
                            borderColor: colors.main,
                            color:
                                newPasswordController.text ==
                                    confirmNewPasswordController.text
                                ? colors.main
                                : colors.textColor.withValues(alpha: .4),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
