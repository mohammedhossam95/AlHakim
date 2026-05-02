import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit() : super(AppointmentsInitial());
}
