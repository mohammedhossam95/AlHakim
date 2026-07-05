import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/features/delegate/domain/entities/medical_center_entity.dart';
import 'package:alhakim/features/delegate/presentation/cubit/delete_medical_center_cubit/delete_medical_center_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/get_medical_centers_cubit/get_medical_centers_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/toggle_medical_center_status_cubit/toggle_medical_center_status_cubit.dart';
import 'package:alhakim/features/delegate/presentation/widgets/delegate_manage_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MedicalCenterItem extends StatelessWidget {
  final MedicalCenterEntity medicalCenter;

  const MedicalCenterItem({super.key, required this.medicalCenter});

  @override
  Widget build(BuildContext context) {
    final isActive = medicalCenter.isActive ?? false;

    return DelegateManageItemCard(
      image: medicalCenter.logo ?? '',
      title: medicalCenter.name ?? '',
      subtitle: medicalCenter.description?.isNotEmpty == true
          ? medicalCenter.description!
          : medicalCenter.address ?? '',
      isActive: isActive,
      activeStatusText: 'center_active'.tr,
      inactiveStatusText: 'center_inactive'.tr,
      activeBadgeText: 'active'.tr,
      inactiveBadgeText: 'frozen'.tr,
      editLabel: 'update'.tr,
      toggleActiveLabel: 'freeze'.tr,
      toggleInactiveLabel: 'activate'.tr,
      deleteLabel: 'delete'.tr,
      onEdit: () async {
        final result = await context.push(
          Routes.updateMedicalCenterScreenRoute,
          extra: medicalCenter,
        );

        if (result == true) {
          if (!context.mounted) return;
          context.read<GetMedicalCentersCubit>().getMedicalCenters();
        }
      },
      onToggle: () {
        Constants.showConfirmDialog(
          context: context,
          title: isActive
              ? 'freeze_medical_center'.tr
              : 'activate_medical_center'.tr,
          content: isActive
              ? 'confirm_freeze_medical_center'.tr
              : 'confirm_activate_medical_center'.tr,
          onYesPressed: () async {
            if (!context.mounted) return;
            context
                .read<ToggleMedicalCenterStatusCubit>()
                .toggleMedicalCenterStatus(medicalCenter.id.toString());
          },
        );
      },
      onDelete: () {
        Constants.showConfirmDialog(
          context: context,
          title: 'delete_medical_center'.tr,
          content: 'confirm_delete_medical_center'.tr,
          onYesPressed: () async {
            if (!context.mounted) return;
            context.read<DeleteMedicalCenterCubit>().deleteMedicalCenter(
              medicalCenter.id.toString(),
            );
          },
        );
      },
    );
  }
}
