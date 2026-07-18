import 'package:equatable/equatable.dart';
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
