import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/share_builder.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/settings/domain/entity/hospital_emergency_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class HospitalEmergencyCard extends StatelessWidget {
  final HospitalEmergencyEntity item;

  const HospitalEmergencyCard({super.key, required this.item});

  Future<void> _callNumber() async {
    final number = item.number?.trim();
    if (number == null || number.isEmpty) return;
    await Constants.launchURL('tel:$number');
  }

  Future<void> _openLocation() async {
    if (item.lat == null || item.lng == null) return;
    await Constants.openGoogleMaps(lat: item.lat!, lng: item.lng!);
  }

  // void _callNumber(String? number) {
  //   if (number == null || number.isEmpty) return;
  //   launchUrl(Uri.parse('tel:$number'));
  // }

  // void _openLocation(String? location) {
  //   if (location == null || location.isEmpty) return;
  //   // لو location عبارة عن رابط جوجل ماب زي في الديزاين
  //   if (location.startsWith('http')) {
  //     launchUrl(Uri.parse(location), mode: LaunchMode.externalApplication);
  //   } else if (item.lat != null && item.lng != null) {
  //     launchUrl(
  //       Uri.parse('https://maps.google.com/?q=${item.lat},${item.lng}'),
  //       mode: LaunchMode.externalApplication,
  //     );
  //   }
  // }

  Future<void> _shareItem(BuildContext context) async {
    await SharePlus.instance.share(
      ShareParams(
        text: ShareTextBuilder.buildFacilityShareText(item),
        subject: 'مشاركة مركز طبي - تطبيق الحكيم',
        sharePositionOrigin: ShareTextBuilder.sharePositionOrigin(context),
      ),
    );
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(),
                    Gaps.hGap10,

                    _CircleActionButton(
                      icon: Icons.call,
                      onTap: () => _callNumber(),
                    ),

                    if (item.lat != null && item.lng != null) ...[
                      Gaps.hGap10,
                      _CircleActionButton(
                        icon: Icons.assistant_direction_rounded,
                        onTap: () => _openLocation(),
                      ),
                    ],
                    Gaps.hGap10,
                    _CircleActionButton(
                      icon: Icons.share,
                      onTap: () => _shareItem(context),
                    ),

                    // _ActionCircleButton(
                    //   icon: Icons.directions_rounded,
                    //   onTap: _openMap,
                    // ),

                    // _ActionCircleButton(
                    //   icon: Icons.phone_rounded,
                    //   onTap: _call,
                    // ),
                  ],
                ),
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
                // صف الأزرار: Call - Direction - Share
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

// class _ActionCircleButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;

//   const _ActionCircleButton({required this.icon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: colors.main.withValues(alpha: 0.08),
//       shape: const CircleBorder(),
//       child: InkWell(
//         customBorder: const CircleBorder(),
//         onTap: onTap,
//         child: SizedBox(
//           width: 46.w,
//           height: 46.w,
//           child: Icon(icon, color: colors.main, size: 22.sp),
//         ),
//       ),
//     );
//   }
// }

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.blue, size: 22),
      ),
    );
  }
}
