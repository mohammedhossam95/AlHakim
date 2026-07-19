import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void handleNotificationNavigation(
  BuildContext context,
  AppNotification notification,
) {
  switch (notification.payload.type) {
    case 'appointment_booked':
      final appointmentId = notification.payload.appointmentId;
      if (appointmentId == null || appointmentId.isEmpty) {
        return;
      }

      if (sessionCubit.state.userType == UserType.patient) {
        context.read<BottomNavBarCubit>().changeCurrentScreen(index: 1);
        if (context.canPop()) {
          context.pop();
        }
      } else {
        context.push(Routes.mainPageRoute);
      }
      break;
    default:
      break;
  }
}
