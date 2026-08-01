import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/core/widgets/split_date_picker.dart';
import 'package:alhakim/features/booking/domain/entities/family_member_entity.dart';
import 'package:alhakim/features/booking/domain/entities/kinship_entity.dart';
import 'package:alhakim/features/booking/presentation/cubit/add_family_member_cubit/add_family_member_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_kinships_cubit/get_kinships_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  final FamilyMemberEntity? member;

  const AddFamilyMemberScreen({super.key, this.member});

  bool get isEditMode => member != null;

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  KinshipEntity? selectedKinship;

  late final TextEditingController _nameController;
  late final TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member?.fullName ?? '');
    _birthDateController =
        TextEditingController(text: widget.member?.birthDate ?? '');

    if (!widget.isEditMode) {
      context.read<GetKinshipsCubit>().getKinships();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.isEditMode) {
      context.read<AddFamilyMemberCubit>().updateFamilyMember(
            id: widget.member!.id!,
            fullName: _nameController.text,
            birthDate: _birthDateController.text,
          );
      return;
    }

    context.read<AddFamilyMemberCubit>().addFamilyMember(
          fullName: _nameController.text,
          birthDate: _birthDateController.text,
          kinship: selectedKinship?.value ?? '',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? 'edit_family_member'.tr : 'add_family_member'.tr,
        ),
      ),
      body: BlocConsumer<AddFamilyMemberCubit, AddFamilyMemberState>(
        listener: (context, state) {
          if (state is AddFamilyMemberSuccess) {
            Constants.showSnakToast(
              context: context,
              type: 1,
              message: state.response.message ?? '',
            );

            context.pop(true);
          }

          if (state is AddFamilyMemberError) {
            Constants.showSnakToast(
              context: context,
              type: 3,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label('full_name'.tr),
                  Gaps.vGap8,
                  MyTextFormField(
                    controller: _nameController,
                    hintText: 'enter_name'.tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter_name'.tr;
                      }
                      return null;
                    },
                  ),
                  Gaps.vGap16,
                  _Label('birth_date'.tr),
                  Gaps.vGap8,
                  SplitDatePicker(
                    controller: _birthDateController,
                    firstYear: 1950,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'birth_date_hint'.tr;
                      }
                      return null;
                    },
                  ),
                  if (!widget.isEditMode) ...[
                    Gaps.vGap16,
                    _Label('relation'.tr),
                    Gaps.vGap8,
                    BlocBuilder<GetKinshipsCubit, GetKinshipsState>(
                      builder: (context, state) {
                        if (state is GetKinshipsLoading) {
                          return SizedBox(
                            height: 55.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state is GetKinshipsSuccess) {
                          final kinships =
                              state.response.data as List<KinshipEntity>;

                          return DropdownButtonFormField<KinshipEntity>(
                            initialValue: kinships.contains(selectedKinship)
                                ? selectedKinship
                                : null,
                            isExpanded: true,
                            validator: (value) {
                              if (value == null) {
                                return 'relation'.tr;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.people_outline,
                                color: colors.main,
                              ),
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
                            hint: Text(
                              'relation'.tr,
                              style: TextStyles.medium12(),
                            ),
                            items: kinships
                                .map(
                                  (e) => DropdownMenuItem<KinshipEntity>(
                                    value: e,
                                    child: Text(e.label ?? ''),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => selectedKinship = value);
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ] else if ((widget.member?.kinship?.label ?? '').isNotEmpty) ...[
                    Gaps.vGap16,
                    _Label('relation'.tr),
                    Gaps.vGap8,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.main.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        widget.member!.kinship!.label!,
                        style: TextStyles.medium14(color: colors.textColor),
                      ),
                    ),
                  ],
                  Gaps.vGap30,
                  state is AddFamilyMemberLoading
                      ? const LoadingView()
                      : MyDefaultButton(
                          onPressed: _submit,
                          btnText: widget.isEditMode ? 'update' : 'add',
                        ),
                ],
              ),
            ),
          );
        },
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
