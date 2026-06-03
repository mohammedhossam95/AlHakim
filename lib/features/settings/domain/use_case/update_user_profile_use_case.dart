import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/settings/domain/repo/setting_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class UpdateUserProfileUseCase
    extends UseCase<UserModel, CompleteProfileParams> {
  final SettingRepo repository;

  UpdateUserProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, UserModel>> call(CompleteProfileParams params) async {
    return await repository.updateUserProfile(params);
  }
}
