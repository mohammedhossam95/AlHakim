import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/booking/domain/usecases/get_family_members_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_family_members_state.dart';

class GetFamilyMembersCubit extends Cubit<GetFamilyMembersState> {
  final GetFamilyMembersUsecase usecase;

  GetFamilyMembersCubit({required this.usecase})
    : super(GetFamilyMembersInitial());

  Future<void> getFamilyMembers() async {
    emit(GetFamilyMembersLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(GetFamilyMembersError(message: l.message ?? '')),
      (r) => emit(GetFamilyMembersSuccess(response: r)),
    );
  }
}
