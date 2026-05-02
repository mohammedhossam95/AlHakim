import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delegate_state.dart';

class DelegateCubit extends Cubit<DelegateState> {
  DelegateCubit() : super(DelegateInitial());
}
