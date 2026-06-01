// ignore_for_file: unused_import

import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/log_utils.dart';
import 'package:alhakim/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:alhakim/features/auth/presentation/cubit/logout/logout_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/delegate/presentation/screens/delegate_dashboard_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/delegate_doctors_screen.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctors_cubit/get_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/screens/clinic_home_screen.dart';
import 'package:alhakim/features/home/presentation/cubit/all_ads_cubit/all_ads_cubit.dart';
import 'package:alhakim/features/home/presentation/cubit/home_bannares_cubit/home_banners_cubit.dart';
import 'package:alhakim/features/home/presentation/screen/home_screen.dart';
import 'package:alhakim/features/queue_management/presentation/screens/queue_management_screen.dart';
import 'package:alhakim/features/settings/presentaion/screens/settings_screen.dart';
import 'package:alhakim/features/specialities/presentation/screens/specialities_screen.dart';
import 'package:alhakim/injection_container.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(const BottomNavBarState());

  int currentIndex = 0;

  Future<void> changeCurrentScreen({required int index}) async {
    currentIndex = index;
    emit(BottomNavBarState(index: currentIndex));
  }
}
