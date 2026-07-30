import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/booking/domain/usecases/delete_family_member_usecase.dart';
import 'package:alhakim/features/booking/domain/usecases/params/delete_family_member_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_family_member_state.dart';

class DeleteFamilyMemberCubit extends Cubit<DeleteFamilyMemberState> {
  final DeleteFamilyMemberUsecase usecase;

  DeleteFamilyMemberCubit({required this.usecase})
      : super(DeleteFamilyMemberInitial());

  Future<void> deleteFamilyMember({required String id}) async {
    emit(DeleteFamilyMemberLoading());

    final result = await usecase(DeleteFamilyMemberParams(id: id));

    result.fold(
      (l) => emit(DeleteFamilyMemberError(message: l.message ?? '')),
      (r) => emit(DeleteFamilyMemberSuccess(response: r)),
    );
  }
}
