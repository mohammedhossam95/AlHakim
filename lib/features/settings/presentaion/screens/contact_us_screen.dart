import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/params/contact_us_param.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/img_manager.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/app_snack_bar.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/core/widgets/tags_text_form_field.dart';
import 'package:alhakim/features/settings/presentaion/cubit/contact_us_cubit/contact_us_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _messageFocus = FocusNode();

  Color get _fieldColor => const Color(0xffd0d0d0).withValues(alpha: 0.2);
  Color get _borderColor => colors.textColor.withValues(alpha: 0.002);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ContactUsCubit, ContactUsState>(
          listener: (context, state) {
            if (state is ContactUsSuccess) {
              showAppSnackBar(
                duration: Duration(seconds: 2),
                context: context,
                message: state.resp.message.toString(),
                type: ToastType.success,
              );
              Navigator.pop(context);
            }
            if (state is ContactUsError) {
              showAppSnackBar(
                context: context,
                message: state.errorMessage.toString(),
                type: ToastType.error,
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      CustomAppBar(title: 'contact_us'.tr, isInTabBar: false),
                      Gaps.vGap30,

                      Center(
                        child: FadeInLeft(
                          delay: Duration(milliseconds: 200),
                          child: Image.asset(
                            ImageAssets.contactUs,
                            height: 150.h,
                            width: 190.w,
                          ),
                        ),
                      ),
                      Gaps.vGap24,

                      // WhatsApp card
                      // InkWell(
                      //   onTap: () {
                      //     onLaunch(
                      //       context: context,
                      //       url: '0123456789',
                      //       platformName: 'Whatsapp',
                      //     );
                      //   },
                      //   child: _buildWhatsAppButton(),
                      // ),
                      Gaps.vGap24,

                      // Divider with text
                      FadeInUp(
                        delay: Duration(milliseconds: 300),
                        child: _buildDividerWithText('contact_us'.tr),
                      ),

                      // Email field
                      Gaps.vGap24,

                      // Message title field
                      FadeInUp(
                        delay: Duration(milliseconds: 400),
                        child: _buildTextField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          hint: 'name'.tr,
                        ),
                      ),
                      Gaps.vGap24,
                      // FadeInUp(
                      //   delay: Duration(milliseconds: 500),
                      //   child: _buildTextField(
                      //     controller: _emailController,
                      //     focusNode: _emailFocus,
                      //     hint: 'email'.tr,
                      //   ),
                      // ),
                      // Gaps.vGap24,

                      // Name field
                      FadeInUp(
                        delay: Duration(milliseconds: 600),
                        child: _buildTextField(
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          hint: 'phone_number'.tr,
                        ),
                      ),
                      Gaps.vGap24,

                      // Message field
                      FadeInUp(
                        delay: Duration(milliseconds: 700),
                        child: _buildTextField(
                          controller: _messageController,
                          focusNode: _messageFocus,
                          hint: 'message'.tr,
                          maxLines: 5,
                        ),
                      ),
                      Gaps.vGap40,

                      // Send button
                      Center(
                        child: BlocBuilder<ContactUsCubit, ContactUsState>(
                          builder: (context, state) {
                            return (state is ContactUsLoading)
                                ? Center(child: CircularProgressIndicator())
                                : FadeInUp(
                                    delay: Duration(milliseconds: 800),
                                    child: MyDefaultButton(
                                      onPressed: () {
                                        ContactUsParam params = ContactUsParam(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          phone: _phoneController.text,
                                          message: _messageController.text,
                                        );
                                        context
                                            .read<ContactUsCubit>()
                                            .contactUsMethod(params);
                                      },
                                      btnText: 'send',
                                    ),
                                  );
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    int maxLines = 1,
  }) {
    return AppTextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      validatorType: ValidatorType.standard,
      hintText: hint,
      maxLines: maxLines,
      backgroundColor: _fieldColor,
      borderColor: _borderColor,
    );
  }

  // Widget _buildWhatsAppButton() {
  //   return Container(
  //     width: 328.w,
  //     height: 48.h,
  //     decoration: BoxDecoration(
  //       color: colors.main.withValues(alpha: 0.07),
  //       borderRadius: BorderRadius.circular(100.r),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(6.r),
  //           decoration: BoxDecoration(
  //             color: colors.main,
  //             shape: BoxShape.circle,
  //           ),
  //           child: SvgPicture.asset(SvgAssets.whatsappIcon),
  //         ),
  //         Gaps.hGap8,
  //         Text('whats_app'.tr, style: TextStyles.bold14(color: colors.main)),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Colors.grey, thickness: 1, endIndent: 10),
        ),
        Text(text, style: TextStyles.medium14()),
        const Expanded(
          child: Divider(color: Colors.grey, thickness: 1, indent: 10),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _messageFocus.dispose();
    super.dispose();
  }
}
