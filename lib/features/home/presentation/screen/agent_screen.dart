import 'dart:ui';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/widgets/agent_doctor_item.dart';
import 'package:alhakim/features/home/data/models/analyze_complaint_response_model.dart';
import 'package:alhakim/features/home/presentation/cubit/analyze_complaint_cubit/analyze_complaint_cubit.dart';
import 'package:alhakim/features/home/presentation/cubit/analyze_complaint_cubit/analyze_complaint_state.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/back_button.dart';
import '/core/widgets/gaps.dart';

class AIAgentScreen extends StatefulWidget {
  const AIAgentScreen({super.key});

  @override
  State<AIAgentScreen> createState() => _AIAgentScreenState();
}

class _AIAgentScreenState extends State<AIAgentScreen> {
  final _complaintController = TextEditingController();

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  void _onAnalyzePressed() {
    final complaint = _complaintController.text.trim();
    if (sessionCubit.state.status != SessionStatus.authenticated) {
      Constants.showLoginWarningDialog(
        context,
        onOkPressed: () {
          context.go(Routes.chooseUserTypeScreenRoute);
        },
      );
      return;
    }
    if (complaint.isEmpty) {
      Constants.showSnakToast(
        context: context,
        type: 3,
        message: 'complaint_required'.tr,
      );
      return;
    }

    context.read<AnalyzeComplaintCubit>().analyzeComplaint(
      complaint: complaint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.lightBackGroundColor,
        body: BlocConsumer<AnalyzeComplaintCubit, AnalyzeComplaintState>(
          listener: (context, state) {
            if (state is AnalyzeComplaintError) {
              Constants.showSnakToast(
                context: context,
                type: 3,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AnalyzeComplaintLoading;
            final complaintData = state is AnalyzeComplaintSuccess
                ? state.response.complaintData
                : null;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: colors.whiteColor.withValues(alpha: 0.8),
                  surfaceTintColor: Colors.transparent,
                  leading: const Center(child: CustomBackButton()),
                  title: Text(
                    'agent_title'.tr,
                    style: TextStyles.bold20(color: colors.main),
                  ),
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.whiteColor.withValues(alpha: 0.8),
                          boxShadow: [
                            BoxShadow(
                              color: colors.main.withValues(alpha: 0.06),
                              blurRadius: 32.r,
                              offset: Offset(0, 12.h),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: Gaps.vGap10),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _ComplaintInputCard(
                        controller: _complaintController,
                        isLoading: isLoading,
                        onAnalyze: _onAnalyzePressed,
                      ),
                      if (complaintData != null) ...[
                        Gaps.vGap20,
                        _AnalysisResultSection(data: complaintData),
                      ],
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
}

class _ComplaintInputCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAnalyze;
  final bool isLoading;

  const _ComplaintInputCard({
    required this.controller,
    required this.onAnalyze,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: colors.main.withValues(alpha: 0.02),
            blurRadius: 24.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.main.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  color: colors.main,
                  size: 28.sp,
                ),
              ),
              Gaps.hGap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'complaint_description'.tr,
                      style: TextStyles.medium14(color: colors.textColor),
                    ),
                    Gaps.vGap4,
                    Text(
                      'agent_desc'.tr,
                      style: TextStyles.regular10(color: colors.textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.vGap24,
          Stack(
            children: [
              MyTextFormField(
                controller: controller,
                hintText: 'complaint_hint'.tr,
                maxLines: 6,
                minLines: 6,
                backgroundColor: const Color(0xffF3F4F6),
              ),
              Positioned(
                bottom: 16.h,
                left: 16.w,
                child: Icon(
                  Icons.edit_note_outlined,
                  color: colors.main.withValues(alpha: 0.4),
                  size: 24.sp,
                ),
              ),
            ],
          ),
          Gaps.vGap32,
          MyDefaultButton(
            isLoading: isLoading,
            onPressed: isLoading ? null : onAnalyze,
            btnText: 'analyze_and_suggest',
            svgAsset: SvgAssets.autoAwesome,
            rightIcon: true,
          ),
        ],
      ),
    );
  }
}

class _AnalysisResultSection extends StatelessWidget {
  final AnalyzeComplaintData data;

  const _AnalysisResultSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ResultBlock(title: 'analysis_title'.tr, content: data.analysis),
        Gaps.vGap16,
        _ResultBlock(title: 'suggestion_title'.tr, content: data.suggestion),
        Gaps.vGap16,
        Text(
          'recommended_doctors'.tr,
          style: TextStyles.bold18(color: colors.textColor),
        ),
        Gaps.vGap16,
        if (data.doctors.isEmpty)
          SizedBox(
            width: double.infinity,
            child: Text(
              'no_recommended_doctors'.tr,
              textAlign: TextAlign.center,
              style: TextStyles.regular14(color: colors.lightTextColor),
            ),
          )
        else
          ...data.doctors.map(
            (doctor) => AgentDoctorItem(doctor: doctor as DoctorEntity),
          ),
      ],
    );
  }
}

class _ResultBlock extends StatelessWidget {
  final String title;
  final String content;

  const _ResultBlock({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        // color: colors.whiteColor,
        color: colors.main.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: colors.main.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: colors.main.withValues(alpha: 0.02),
            blurRadius: 24.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: colors.main, size: 24.sp),
              Gaps.hGap12,
              Text(title, style: TextStyles.bold18(color: colors.main)),
            ],
          ),
          Gaps.vGap12,
          Text(
            content,
            style: TextStyles.regular14(
              color: colors.textColor,
            ).copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
