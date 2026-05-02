import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/auth/presentation/widgets/user_type_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/enums.dart';
import '/core/utils/values/assets.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/injection_container.dart';

class ChooseUserTypeScreen extends StatefulWidget {
  const ChooseUserTypeScreen({super.key});

  @override
  State<ChooseUserTypeScreen> createState() => _ChooseUserTypeScreenState();
}

class _ChooseUserTypeScreenState extends State<ChooseUserTypeScreen> {
  late UserType _selectedUserType;

  @override
  void initState() {
    super.initState();
    _selectedUserType = sessionCubit.state.userType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Illustration section
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.secondary.withValues(alpha: 0.3),
                      colors.backGround,
                    ],
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    ImgAssets.chooseUserTypeImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Gaps.vGap32,
              // Text section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Text(
                      'choose_account_type'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyles.semiBold16(color: colors.textColor),
                    ),
                    Gaps.vGap12,
                    Text(
                      'choose_account_type_description'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyles.regular14(
                        color: colors.textColor.withValues(alpha: 0.7),
                      ),
                    ),
                    Gaps.vGap32,

                    UserTypeCardWidget(
                      title: 'patient_account'.tr,
                      description: 'patient_account_description'.tr,
                      userType: UserType.patient,
                      isSelected: _selectedUserType == UserType.patient,
                      isProminent: true,
                      onTap: () {
                        setState(() {
                          _selectedUserType = UserType.patient;
                        });
                      },
                    ),
                    Gaps.vGap20,
                    Row(
                      children: [
                        Expanded(
                          child: UserTypeCardWidget(
                            title: 'doctor_account'.tr,
                            description: 'doctor_account_description'.tr,
                            userType: UserType.doctor,
                            isSelected: _selectedUserType == UserType.doctor,
                            onTap: () {
                              setState(() {
                                _selectedUserType = UserType.doctor;
                              });
                            },
                          ),
                        ),
                        Gaps.hGap16,
                        Expanded(
                          child: UserTypeCardWidget(
                            title: 'delegate_account'.tr,
                            description: 'delegate_account_description'.tr,
                            userType: UserType.delegate,
                            isSelected: _selectedUserType == UserType.delegate,
                            onTap: () {
                              setState(() {
                                _selectedUserType = UserType.delegate;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Gaps.vGap40,
                    MyDefaultButton(
                      btnText: 'continue',
                      onPressed: () {
                        final session = BlocProvider.of<SessionCubit>(context);
                        session.setUserType(_selectedUserType);
                        context.pushNamed(Routes.loginScreenRoute);
                      },
                    ),
                  ],
                ),
              ),
              Gaps.vGap40,
            ],
          ),
        ),
      ),
    );
  }
}
