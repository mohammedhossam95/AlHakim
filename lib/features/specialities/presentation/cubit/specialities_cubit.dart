import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'specialities_state.dart';

class SpecialitiesCubit extends Cubit<SpecialitiesState> {
  SpecialitiesCubit() : super(SpecialitiesInitial());
}
