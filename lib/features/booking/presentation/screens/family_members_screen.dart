import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/booking/domain/entities/family_member_entity.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_family_members_cubit/get_family_members_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  @override
  void initState() {
    super.initState();

    context.read<GetFamilyMembersCubit>().getFamilyMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("family_members".tr)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(Routes.addFamilyMemberScreenRoute);

          if (result == true) {
            if (!context.mounted) return;
            context.read<GetFamilyMembersCubit>().getFamilyMembers();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<GetFamilyMembersCubit, GetFamilyMembersState>(
        builder: (context, state) {
          if (state is GetFamilyMembersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetFamilyMembersError) {
            return Center(child: Text(state.message));
          }

          List<FamilyMemberEntity> familyMembers = [];

          if (state is GetFamilyMembersSuccess) {
            familyMembers = state.response.data as List<FamilyMemberEntity>;
          }

          return Padding(
            padding: EdgeInsets.all(16.w),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,

                    vertical: 4.h,
                  ),

                  decoration: BoxDecoration(
                    color: colors.secondary.withValues(alpha: .2),

                    borderRadius: BorderRadius.circular(20.r),
                  ),

                  child: Text(
                    "${familyMembers.length} ${"members".tr}",

                    style: TextStyles.medium12(color: colors.secondary),
                  ),
                ),

                Gaps.vGap16,

                Expanded(
                  child: familyMembers.isEmpty
                      ? Center(child: ErrorText(text: "noData".tr, width: 300))
                      : ListView.separated(
                          itemCount: familyMembers.length,

                          separatorBuilder: (_, _) => Gaps.vGap12,

                          itemBuilder: (context, index) {
                            return _FamilyItem(
                              item: familyMembers[index],

                              onTap: () {
                                Navigator.pop(context, familyMembers[index]);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FamilyItem extends StatelessWidget {
  final FamilyMemberEntity item;

  final VoidCallback onTap;

  const _FamilyItem({required this.item, required this.onTap});

  String getAge(String? birthDate) {
    if (birthDate == null) {
      return "-";
    }

    final date = DateFormat("yyyy-MM-dd").parse(birthDate);

    final age = DateTime.now().year - date.year;

    return "$age";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.all(14.w),

        decoration: BoxDecoration(
          color: colors.whiteColor,

          borderRadius: BorderRadius.circular(16.r),

          border: Border.all(color: colors.main, width: 1.5),
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,

              backgroundColor: colors.main.withValues(alpha: .1),

              child: Icon(Icons.person, color: colors.main),
            ),

            Gaps.hGap12,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(item.fullName ?? '', style: TextStyles.semiBold16()),

                  Gaps.vGap4,

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,

                          vertical: 2.h,
                        ),

                        decoration: BoxDecoration(
                          color: colors.secondary.withValues(alpha: .2),

                          borderRadius: BorderRadius.circular(10.r),
                        ),

                        child: Text(
                          item.kinship?.label ?? '',

                          style: TextStyles.medium12(color: colors.secondary),
                        ),
                      ),

                      Gaps.hGap8,

                      Text(
                        "${"age".tr}: ${getAge(item.birthDate)}",

                        style: TextStyles.medium12(
                          color: colors.lightTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Icon(Icons.keyboard_arrow_left_rounded, color: colors.main),
          ],
        ),
      ),
    );
  }
}
