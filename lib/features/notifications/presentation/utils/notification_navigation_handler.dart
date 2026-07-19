import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:flutter/material.dart';
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
      context.push(Routes.appointmentsScreenRoute);
      break;
    default:
      break;
  }
}
