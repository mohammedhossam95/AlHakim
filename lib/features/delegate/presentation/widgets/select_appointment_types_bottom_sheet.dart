import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/booking/domain/entities/appointment_type_entity.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_appointment_types_cubit/get_appointment_types_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class SelectAppointmentTypesBottomSheet extends StatefulWidget {
  final List<AppointmentTypeEntity>? selectedTypes;

  const SelectAppointmentTypesBottomSheet({
    super.key,
    this.selectedTypes,
  });

  @override
  State<SelectAppointmentTypesBottomSheet> createState() =>
      _SelectAppointmentTypesBottomSheetState();
}

class _SelectAppointmentTypesBottomSheetState
    extends State<SelectAppointmentTypesBottomSheet> {
  late Map<int, AppointmentTypeEntity> _selectedTypes;

  @override
  void initState() {
    super.initState();
    _selectedTypes = {
      for (final type in widget.selectedTypes ?? <AppointmentTypeEntity>[])
        type.id: type,
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GetAppointmentTypesCubit>().getAppointmentTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.backGround,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.lightTextColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            Gaps.vGap16,
            Text(
              'appointment_types'.tr,
              style: TextStyles.semiBold18(),
            ),
            Gaps.vGap4,
            Text(
              'select_appointment_types_desc'.tr,
              style: TextStyles.medium12(color: colors.lightTextColor),
            ),
            Gaps.vGap16,
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300.h),
              child: BlocBuilder<GetAppointmentTypesCubit,
                  GetAppointmentTypesState>(
                builder: (context, state) {
                  if (state is GetAppointmentTypesLoading ||
                      state is GetAppointmentTypesInitial) {
                    return const _AppointmentTypesShimmer();
                  }

                  if (state is GetAppointmentTypesError) {
                    return SizedBox(
                      height: 180.h,
                      child: Center(
                        child: Text(
                          state.message,
                          style:
                              TextStyles.medium12(color: colors.lightTextColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final types = state is GetAppointmentTypesSuccess
                      ? (state.response.data ?? [])
                            .whereType<AppointmentTypeEntity>()
                            .where((e) => e.id > 0)
                            .toList()
                      : <AppointmentTypeEntity>[];

                  if (types.isEmpty) {
                    return SizedBox(
                      height: 160.h,
                      child: Center(
                        child: Text(
                          'no_appointment_types'.tr,
                          style: TextStyles.medium14(
                            color: colors.lightTextColor,
                          ),
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: types
                          .map((type) {
                            final isSelected =
                                _selectedTypes.containsKey(type.id);
                            return FilterChip(
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedTypes[type.id] = type;
                                  } else {
                                    _selectedTypes.remove(type.id);
                                  }
                                });
                              },
                              backgroundColor: colors.whiteColor,
                              selectedColor: colors.main.withValues(
                                alpha: 0.12,
                              ),
                              side: BorderSide(
                                color: isSelected
                                    ? colors.main
                                    : colors.main.withValues(alpha: 0.12),
                                width: isSelected ? 2.w : 1.w,
                              ),
                              label: Text(
                                type.name,
                                style: TextStyles.medium13(
                                  color: isSelected
                                      ? colors.main
                                      : colors.textColor,
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  );
                },
              ),
            ),
            Gaps.vGap20,
            Row(
              children: [
                Expanded(
                  child: MyDefaultButton(
                    btnText: 'cancel',
                    color: colors.whiteColor,
                    textColor: colors.textColor,
                    borderColor: colors.main,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Gaps.hGap12,
                Expanded(
                  child: MyDefaultButton(
                    btnText: 'save',
                    onPressed: () {
                      if (_selectedTypes.isEmpty) {
                        Constants.showSnakToast(
                          context: context,
                          type: 2,
                          message: 'must_select_at_least_one_appointment_type'
                              .tr,
                        );
                        return;
                      }
                      Navigator.pop(
                        context,
                        _selectedTypes.values.toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentTypesShimmer extends StatelessWidget {
  const _AppointmentTypesShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColorShimmer,
      highlightColor: highlightColorShimmer,
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: List.generate(
          6,
          (index) => Container(
            height: 36.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      ),
    );
  }
}
