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

      _openAppointmentsTab(context);
      break;
    case 'doctor_rescheduled':
      _openAppointmentsTab(context);
      break;
    case 'appointment_completed':
      context.pushNamed(Routes.patientOffersRoute);
      break;

    default:
      break;
  }
}

/// Index 1 is "My appointments" for patients and "Queue management" for
/// doctors, so both land where they can see the booking.
void _openAppointmentsTab(BuildContext context) {
  final session = sessionCubit.state;
  final hasAppointmentsTab =
      session.userType == UserType.patient ||
      (session.isDoctor && !session.needsDoctorSelection);

  if (!hasAppointmentsTab) {
    context.go(Routes.mainPageRoute);
    return;
  }

  context.read<BottomNavBarCubit>().changeCurrentScreen(index: 1);
  if (context.canPop()) {
    context.pop();
  }
}
