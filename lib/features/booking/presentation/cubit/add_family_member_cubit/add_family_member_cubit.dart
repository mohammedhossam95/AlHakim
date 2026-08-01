import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/booking/domain/usecases/add_family_member_usecase.dart';
import 'package:alhakim/features/booking/domain/usecases/params/update_family_member_params.dart';
import 'package:alhakim/features/booking/domain/usecases/update_family_member_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_family_member_state.dart';

class AddFamilyMemberCubit extends Cubit<AddFamilyMemberState> {
  final AddFamilyMemberUsecase addUsecase;
  final UpdateFamilyMemberUsecase updateUsecase;

  AddFamilyMemberCubit({
    required this.addUsecase,
    required this.updateUsecase,
  }) : super(AddFamilyMemberInitial());

  Future<void> addFamilyMember({
    required String fullName,
    required String birthDate,
    required String kinship,
  }) async {
    emit(AddFamilyMemberLoading());

    final result = await addUsecase(
      fullName: fullName,
      birthDate: birthDate,
      kinship: kinship,
    );

    result.fold(
      (l) => emit(AddFamilyMemberError(message: l.message ?? '')),
      (r) => emit(AddFamilyMemberSuccess(response: r)),
    );
  }

  Future<void> updateFamilyMember({
    required String id,
    required String fullName,
    required String birthDate,
  }) async {
    emit(AddFamilyMemberLoading());

    final result = await updateUsecase(
      UpdateFamilyMemberParams(
        id: id,
        fullName: fullName,
        birthDate: birthDate,
      ),
    );

    result.fold(
      (l) => emit(AddFamilyMemberError(message: l.message ?? '')),
      (r) => emit(AddFamilyMemberSuccess(response: r)),
    );
  }
}
