import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/booking/domain/usecases/add_family_member_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_family_member_state.dart';

class AddFamilyMemberCubit extends Cubit<AddFamilyMemberState> {
  final AddFamilyMemberUsecase usecase;

  AddFamilyMemberCubit({required this.usecase})
    : super(AddFamilyMemberInitial());

  Future<void> addFamilyMember({
    required String fullName,
    required String birthDate,
    required String kinship,
  }) async {
    emit(AddFamilyMemberLoading());

    final result = await usecase(
      fullName: fullName,
      birthDate: birthDate,
      kinship: kinship,
    );

    result.fold(
      (l) => emit(AddFamilyMemberError(message: l.message ?? '')),
      (r) => emit(AddFamilyMemberSuccess(response: r)),
    );
  }
}
