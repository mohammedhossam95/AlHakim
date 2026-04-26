// ignore_for_file: unused_import

import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/home/presentation/cubit/home_bannares_cubit/home_banners_cubit.dart';
import 'package:alhakim/features/home/presentation/screen/home_screen.dart';
import 'package:alhakim/features/specialities/presentation/screens/specialities_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/settings/presentaion/screens/settings_screen.dart';
import '/injection_container.dart';
import '../../../../home/presentation/cubit/all_ads_cubit/all_ads_cubit.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(const BottomNavBarState());

  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    SpecialitiesScreen(),

    Container(),
    const SettingsScreen(),
  ];

  Future<void> changeCurrentScreen({required int index}) async {
    currentIndex = index;

    emit(BottomNavBarState(index: currentIndex));
  }
}
