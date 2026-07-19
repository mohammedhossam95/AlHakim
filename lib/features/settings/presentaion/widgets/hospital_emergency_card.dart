import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/settings/domain/entity/hospital_emergency_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HospitalEmergencyCard extends StatelessWidget {
  final HospitalEmergencyEntity item;

  const HospitalEmergencyCard({super.key, required this.item});

  Future<void> _call() async {
    final number = item.number?.trim();
    if (number == null || number.isEmpty) return;
    await Constants.launchURL('tel:$number');
  }

  Future<void> _openMap() async {
    if (item.lat == null || item.lng == null) return;
    await Constants.openGoogleMaps(lat: item.lat!, lng: item.lng!);
  }

  @override
  Widget build(BuildContext context) {
    final tags = item.tags?.where((t) => t.trim().isNotEmpty).toList() ?? [];

    return Container(
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colors.textColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DiffImage(
            image: item.image,
            height: 168.h,
            width: double.infinity,
            fitType: BoxFit.scaleDown,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            radius: 0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? '',
                            style: TextStyles.bold16(color: colors.main),
                          ),
                          if ((item.location ?? '').isNotEmpty) ...[
                            Gaps.vGap4,
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16.sp,
                                  color: colors.lightTextColor,
                                ),
                                Gaps.hGap4,
                                Expanded(
                                  child: Text(
                                    item.location!,
                                    style: TextStyles.regular12(
                                      color: colors.lightTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Gaps.hGap10,
                    if (item.lat != null && item.lng != null) ...[
                      Gaps.hGap8,
                      _ActionCircleButton(
                        icon: Icons.directions_rounded,
                        onTap: _openMap,
                      ),
                    ],
                    Gaps.hGap10,
                    _ActionCircleButton(
                      icon: Icons.phone_rounded,
                      onTap: _call,
                    ),
                  ],
                ),
                if ((item.description ?? '').isNotEmpty) ...[
                  Gaps.vGap10,
                  Text(
                    item.description!,
                    style: TextStyles.regular13(color: colors.lightTextColor),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (tags.isNotEmpty) ...[
                  Gaps.vGap12,
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: tags
                        .map(
                          (tag) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.backGround,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: colors.main.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyles.medium12(
                                color: colors.lightTextColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.main.withValues(alpha: 0.08),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 46.w,
          height: 46.w,
          child: Icon(icon, color: colors.main, size: 22.sp),
        ),
      ),
    );
  }
}
