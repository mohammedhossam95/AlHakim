import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/notifications/presentation/cubits/notifications_count_cubit/notifications_count_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NotificationsIconButton extends StatelessWidget {
  const NotificationsIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, sessionState) {
        if (sessionState.status != SessionStatus.authenticated) {
          return const SizedBox.shrink();
        }

        return BlocProvider(
          create: (_) =>
              ServiceLocator.instance<NotificationsCountCubit>()..fGetCount(),
          child: BlocBuilder<NotificationsCountCubit, NotificationsCountState>(
            builder: (context, countState) {
              final unreadCount = countState is NotificationsCountSuccessState
                  ? countState.unreadCount
                  : 0;

              return InkWell(
                onTap: () {
                  context.push(Routes.notificationsScreenRoute);
                },
                borderRadius: BorderRadius.circular(14.r),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: colors.main.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: colors.main,
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: -2.h,
                        right: -2.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.errorColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          constraints: BoxConstraints(minWidth: 16.w),
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            textAlign: TextAlign.center,
                            style: TextStyles.bold10(color: colors.whiteColor),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
