import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/booking/domain/entities/kinship_entity.dart';
import 'package:alhakim/features/booking/presentation/cubit/add_family_member_cubit/add_family_member_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_kinships_cubit/get_kinships_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  KinshipEntity? selectedKinship;

  final _nameController = TextEditingController();

  final _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<GetKinshipsCubit>().getKinships();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("add_family_member".tr)),

      body: BlocConsumer<AddFamilyMemberCubit, AddFamilyMemberState>(
        listener: (context, state) {
          if (state is AddFamilyMemberSuccess) {
            Constants.showSnakToast(
              context: context,
              type: 1,
              message: state.response.message,
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
                  /// name
                  _Label("full_name".tr),

                  Gaps.vGap8,

                  MyTextFormField(
                    controller: _nameController,

                    hintText: "enter_name".tr,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "enter_name".tr;
                      }

                      return null;
                    },
                  ),

                  Gaps.vGap16,

                  /// birthdate
                  _Label("birth_date".tr),

                  Gaps.vGap8,

                  MyTextFormField(
                    controller: _birthDateController,

                    hintText: "birth_date_hint".tr,

                    readOnly: true,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "birth_date_hint".tr;
                      }

                      return null;
                    },

                    prefixIcon: Icon(Icons.calendar_today, color: colors.main),

                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,

                        initialDate: DateTime.now(),

                        firstDate: DateTime(1950),

                        lastDate: DateTime.now(),
                      );

                      if (picked != null) {
                        _birthDateController.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),

                  Gaps.vGap16,

                  /// relation
                  _Label("relation".tr),

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
                              return "relation".tr;
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
                            "relation".tr,

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
                            setState(() {
                              selectedKinship = value;
                            });
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),

                  Gaps.vGap30,

                  /// button
                  state is AddFamilyMemberLoading
                      ? LoadingView()
                      : MyDefaultButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            context
                                .read<AddFamilyMemberCubit>()
                                .addFamilyMember(
                                  fullName: _nameController.text,

                                  birthDate: _birthDateController.text,

                                  kinship: selectedKinship?.value ?? '',
                                );
                          },

                          btnText: "add",
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
