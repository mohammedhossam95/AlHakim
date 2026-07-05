import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/delegate/domain/entities/medical_center_entity.dart';
import 'package:alhakim/features/delegate/presentation/cubit/delete_medical_center_cubit/delete_medical_center_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/get_medical_centers_cubit/get_medical_centers_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/toggle_medical_center_status_cubit/toggle_medical_center_status_cubit.dart';
import 'package:alhakim/features/delegate/presentation/widgets/delegate_manage_list_shimmer.dart';
import 'package:alhakim/features/delegate/presentation/widgets/medical_center_item.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DelegateMedicalCentersScreen extends StatefulWidget {
  const DelegateMedicalCentersScreen({super.key});

  @override
  State<DelegateMedicalCentersScreen> createState() =>
      _DelegateMedicalCentersScreenState();
}

class _DelegateMedicalCentersScreenState
    extends State<DelegateMedicalCentersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetMedicalCentersCubit>().getMedicalCenters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(title: Text('medical_centers'.tr)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(Routes.addMedicalCenterScreenRoute);
          if (result == true) {
            if (!context.mounted) return;
            context.read<GetMedicalCentersCubit>().getMedicalCenters();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteMedicalCenterCubit, DeleteMedicalCenterState>(
            listener: (context, state) {
              if (state is DeleteMedicalCenterLoading) {
                Constants.showLoading(context);
              }
              if (state is DeleteMedicalCenterSuccess) {
                context.read<GetMedicalCentersCubit>().getMedicalCenters();
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  message: state.response.message ?? '',
                  type: 1,
                );
              }
              if (state is DeleteMedicalCenterError) {
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  message: state.message,
                  type: 3,
                );
              }
            },
          ),
          BlocListener<
            ToggleMedicalCenterStatusCubit,
            ToggleMedicalCenterStatusState
          >(
            listener: (context, state) {
              if (state is ToggleMedicalCenterStatusLoading) {
                Constants.showLoading(context);
              }
              if (state is ToggleMedicalCenterStatusSuccess) {
                context.read<GetMedicalCentersCubit>().getMedicalCenters();
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  message: state.response.message ?? '',
                  type: 1,
                );
              }
              if (state is ToggleMedicalCenterStatusError) {
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  message: state.message,
                  type: 3,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<GetMedicalCentersCubit, GetMedicalCentersState>(
          builder: (context, state) {
            if (state is GetMedicalCentersLoading) {
              return const DelegateManageListShimmer();
            }

            if (state is GetMedicalCentersError) {
              return Center(
                child: ErrorText(
                  text: state.message,
                  width: 300,
                  onRetry: () {
                    context.read<GetMedicalCentersCubit>().getMedicalCenters();
                  },
                ),
              );
            }

            if (state is GetMedicalCentersSuccess) {
              final centers = state.response.data as List<MedicalCenterEntity>;

              if (centers.isEmpty) {
                return Center(
                  child: Text(
                    'no_medical_centers'.tr,
                    style: TextStyles.medium14(color: colors.lightTextColor),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: centers.length,
                separatorBuilder: (_, _) => Gaps.vGap18,
                itemBuilder: (context, index) {
                  return MedicalCenterItem(medicalCenter: centers[index]);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
