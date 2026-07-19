import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/no_data_found.dart';
import 'package:alhakim/core/widgets/shimmer/notifications_list_shimmer.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:alhakim/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import 'package:alhakim/features/notifications/presentation/utils/notification_navigation_handler.dart';
import 'package:alhakim/features/notifications/presentation/widget/notification_item.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NotificationsCubit>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      const CustomBackButton(),
                      Gaps.hGap16,
                      Expanded(
                        child: Text(
                          'notifications'.tr,
                          style: TextStyles.bold16(color: colors.textColor),
                        ),
                      ),
                      if (state.hasUnreadNotifications)
                        TextButton(
                          onPressed: state.isMarkingAllAsRead
                              ? null
                              : () {
                                  context
                                      .read<NotificationsCubit>()
                                      .markAllAsRead();
                                },
                          child: state.isMarkingAllAsRead
                              ? SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.main,
                                  ),
                                )
                              : Text(
                                  'mark_all_as_read'.tr,
                                  style: TextStyles.medium12(
                                    color: colors.main,
                                  ),
                                ),
                        ),
                    ],
                  );
                },
              ),
              Gaps.vGap12,
              Expanded(
                child: BlocConsumer<NotificationsCubit, NotificationsState>(
                  listener: (context, state) {
                    if (state.errorMessage != null &&
                        state.errorMessage!.isNotEmpty &&
                        state.notifications.isNotEmpty) {
                      Constants.showSnakToast(
                        context: context,
                        message: state.errorMessage!,
                        type: 3,
                      );
                    }
                    if (state.actionMessage != null &&
                        state.actionMessage!.isNotEmpty) {
                      Constants.showSnakToast(
                        context: context,
                        message: state.actionMessage!,
                        type: 1,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.status == NotificationsStatus.loading &&
                        state.notifications.isEmpty) {
                      return const NotificationsListShimmer();
                    }

                    if (state.status == NotificationsStatus.failure &&
                        state.notifications.isEmpty) {
                      return ErrorText(
                        width: 1.sw,
                        text: state.errorMessage,
                        onRetry: () {
                          context.read<NotificationsCubit>().getNotifications();
                        },
                      );
                    }

                    if (state.status == NotificationsStatus.success &&
                        state.notifications.isEmpty) {
                      return Center(
                        child: NoDataFound(text: 'no_notifications'.tr),
                      );
                    }

                    return RefreshIndicator(
                      color: colors.main,
                      onRefresh: () {
                        return context
                            .read<NotificationsCubit>()
                            .refreshNotifications();
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.notifications.length,
                        separatorBuilder: (_, _) => Gaps.vGap4,
                        itemBuilder: (context, index) {
                          final AppNotification notification =
                              state.notifications[index];
                          return NotificationCard(
                            notification: notification,
                            isLoading: state.isMarkingNotificationAsRead(
                              notification.id,
                            ),
                            onTap: () async {
                              await context
                                  .read<NotificationsCubit>()
                                  .markAsRead(notification.id);

                              if (!context.mounted) {
                                return;
                              }

                              handleNotificationNavigation(
                                context,
                                notification,
                              );
                            },
                          );
                        },
                      ),
                    );
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
