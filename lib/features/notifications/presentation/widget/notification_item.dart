import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final bool isLoading;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localeCode =
        AppLocalizations.of(context)?.locale?.languageCode ?? 'en';
    final createdAtLocal = notification.createdAt.toLocal();
    final timeLabel = timeago.format(createdAtLocal, locale: localeCode);
    final dateLabel = DateFormat('hh:mm a', localeCode).format(createdAtLocal);

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: notification.isRead
              ? colors.whiteColor
              : colors.main.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: notification.isRead
                ? colors.lightTextColor.withValues(alpha: 0.15)
                : colors.main.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: colors.main.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: colors.main,
                size: 22.sp,
              ),
            ),
            Gaps.hGap10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.payload.title,
                          style: TextStyles.semiBold14(color: colors.textColor),
                        ),
                      ),
                      if (isLoading)
                        SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.main,
                          ),
                        )
                      else
                        Text(
                          dateLabel,
                          style: TextStyles.regular12(color: colors.main),
                        ),
                    ],
                  ),
                  Gaps.vGap8,
                  Text(
                    notification.payload.body,
                    style: TextStyles.regular13(color: colors.textColor),
                  ),
                  Gaps.vGap8,
                  Text(
                    timeLabel,
                    style: TextStyles.regular10(color: colors.lightTextColor),
                  ),
                ],
              ),
            ),
            if (!notification.isRead && !isLoading) ...[
              Gaps.hGap8,
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: colors.main,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
