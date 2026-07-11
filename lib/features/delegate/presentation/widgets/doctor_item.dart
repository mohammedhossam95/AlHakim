import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/features/delegate/presentation/widgets/delegate_manage_item_card.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/delete_doctor/delete_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctors_cubit/get_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggel_doctor_status/toggel_doctor_status_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DoctorItem extends StatelessWidget {
  final DoctorEntity doctor;
  final VoidCallback? onTap;
  final bool showActions;

  const DoctorItem({
    super.key,
    required this.doctor,
    this.onTap,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = doctor.isActive ?? false;
    final name = appLocalizations.isArLocale
        ? doctor.name?.ar ?? ''
        : doctor.name?.en ?? '';

    final card = DelegateManageItemCard(
      image:
          doctor.profileImage ??
          'https://cdn-icons-png.flaticon.com/512/149/149071.png',
      title: name,
      subtitle: doctor.specialty?.name ?? '',
      isActive: isActive,
      activeStatusText: 'clinic_open'.tr,
      inactiveStatusText: 'clinic_closed'.tr,
      editLabel: 'update'.tr,
      toggleActiveLabel: 'freeze'.tr,
      toggleInactiveLabel: 'activate'.tr,
      deleteLabel: 'delete'.tr,
      showActions: showActions,
      onEdit: showActions
          ? () async {
              final result = await context.push(
                Routes.updateDoctorScreenRoute,
                extra: doctor,
              );

              if (result == true) {
                if (!context.mounted) return;
                context.read<GetDoctorsCubit>().getDoctors();
              }
            }
          : null,
      onToggle: showActions
          ? () {
              Constants.showConfirmDialog(
                context: context,
                title: isActive ? 'freeze_doctor'.tr : 'activate_doctor'.tr,
                content: isActive
                    ? 'confirm_freeze_doctor'.tr
                    : 'confirm_activate_doctor'.tr,
                onYesPressed: () async {
                  if (!context.mounted) return;
                  context
                      .read<ToggelDoctorStatusCubit>()
                      .toggleDoctorStatus(doctor.id ?? '');
                },
              );
            }
          : null,
      onDelete: showActions
          ? () {
              Constants.showConfirmDialog(
                context: context,
                title: 'delete_doctor'.tr,
                content: 'confirm_delete_doctor'.tr,
                onYesPressed: () async {
                  if (!context.mounted) return;
                  context.read<DeleteDoctorCubit>().deleteDoctor(doctor.id ?? '');
                },
              );
            }
          : null,
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: card,
    );
  }
}
