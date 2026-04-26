import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/core/widgets/no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/features/notifications/domain/entities/get_notifications_response.dart';
import '/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import '/features/notifications/presentation/widget/notification_item.dart';
import '/injection_container.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  initState() {
    BlocProvider.of<NotificationsCubit>(context).fGetNotifications();
    super.initState();
  }

  late AppLocalizations locale;
  late TextTheme theme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.vGap20,
              Row(
                children: [
                  CustomBackButton(),
                  Gaps.hGap16,
                  Text(
                    'notifications'.tr,
                    style: TextStyles.bold16(color: colors.textColor),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is NotificationsSuccessState) {
                      NotificationData data =
                          state.response.data as NotificationData;
                      List<MyNotification> notifications =
                          data.notifications as List<MyNotification>;
                      return notifications.isNotEmpty
                          ? ListView.separated(
                              separatorBuilder: (context, index) => Gaps.vGap4,
                              itemCount: notifications.length,
                              itemBuilder: ((context, index) =>
                                  NotificationCard(
                                    notification: notifications[index],
                                  )),
                            )
                          : Center(child: NoDataFound(text: 'noData'.tr));
                    } else if (state is NotificationsFailureState) {
                      return Center(
                        // child: NoDataFound(text: state.errorMessage.toString()),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Gaps.vGap4,
                          itemCount: 6,
                          itemBuilder: ((context, index) => NotificationCard(
                            notification: MyNotification(
                              id: index,
                              title: 'عنوان الإشعار',
                              message: 'استلمت طلب جديد',
                              createdAt: DateTime.now().toString(),
                              createdAtHuman: DateTime.now().toString(),
                            ),
                          )),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
