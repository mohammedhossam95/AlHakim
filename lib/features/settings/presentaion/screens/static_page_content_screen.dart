import 'package:alhakim/core/utils/enums.dart'; // تأكد من استيراد النوع
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/no_data_found.dart';
import 'package:alhakim/features/settings/domain/entity/static_page_entity.dart';
import 'package:alhakim/features/settings/presentaion/cubit/static_page_content_cubit/static_page_content_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class StaticPageScreen extends StatefulWidget {
  final StaticPageType type;

  const StaticPageScreen({super.key, required this.type});

  @override
  State<StaticPageScreen> createState() => _StaticPageScreenState();
}

class _StaticPageScreenState extends State<StaticPageScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StaticPageContentCubit>().getSataicPageContent(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StaticPageContentCubit, StaticPageContentState>(
          builder: (context, state) {
            StaticPageEntity? entity;
            if (state is StaticPageContentLoaded) {
              entity = state.resp.data as StaticPageEntity;
            }

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: CustomAppBar(
                    title: entity?.key ?? '',
                    isInTabBar: false,
                  ),
                ),

                Expanded(
                  child: FadeInUp(
                    delay: Duration(milliseconds: 400),
                    child: _buildStateContent(state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStateContent(StaticPageContentState state) {
    if (state is StaticPageContentLoading) {
      return _buildShimmer();
    }

    if (state is StaticPageContentLoaded) {
      final data = state.resp.data as StaticPageEntity;
      return _buildMainContent(data);
    }

    if (state is StaticPageContentError) {
      return NoDataFound(text: state.message.toString());
    }

    return const SizedBox.shrink();
  }

  Widget _buildMainContent(StaticPageEntity data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 30.h, 16.w, 16.w),
        decoration: BoxDecoration(
          color: colors.main.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          data.value ?? '',
          style: TextStyles.semiBold14().copyWith(
            height: 2,
            color: colors.textColor.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 500.h,
              margin: EdgeInsets.only(top: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),

            Positioned(
              top: 0,
              right: 12.w,
              child: Container(
                width: 120.w,
                height: 35.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
