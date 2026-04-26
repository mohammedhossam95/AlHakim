import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserEntity?> {
  UserCubit() : super(sharedPreferences.getUser());

  void updateUser(UserModel user) {
    sharedPreferences.saveUser(user);
    emit(user);
  }

  void loadUser() {
    emit(sharedPreferences.getUser());
  }
}
