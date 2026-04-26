import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '/core/widgets/diff_img.dart';
// import '/core/utils/image_manager.dart';
import '/core/widgets/gaps.dart';
import '/features/notifications/domain/entities/get_notifications_response.dart';
// import '/features/tasks/domain/entities/task_entity.dart';
import '/injection_container.dart';

class NotificationCard extends StatelessWidget {
  final MyNotification notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DiffImage(
                isCircle: true,
                width: 50.0.w,
                height: 50.0.w,
                radius: 25.w,
                image: notification.imageUrl ?? '',
                userName: notification.title ?? '',
                userNameColor: colors.whiteColor,
              ),
              Gaps.hGap10,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title ?? '',
                            style: TextStyles.regular14(
                              color: colors.textColor,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('hh:mm a').format(
                            DateTime.parse(notification.createdAtHuman ?? ''),
                          ),
                          style: TextStyles.regular12(color: colors.main),
                        ),
                      ],
                    ),
                    Gaps.vGap8,
                    Text(
                      notification.message ?? '',
                      style: TextStyles.regular13(color: colors.textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
