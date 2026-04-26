import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/home/domain/use_case/get_home_bannars_usecase.dart';
import 'package:alhakim/features/home/presentation/cubit/home_bannares_cubit/home_banners_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBannaresCubit extends Cubit<HomeBannaresState> {
  final GetHomeBannarsUsecase usecase;

  HomeBannaresCubit({required this.usecase})
    : super(HomeBannaresInitialState());

  Future<void> getHomeBanners() async {
    try {
      emit(HomeBannaresLoadingState());

      final result = await usecase.call(NoParams());

      result.fold(
        (failure) =>
            emit(HomeBannaresErrorState(message: failure.message ?? '')),
        (response) => emit(HomeBannaresSuccessState(response: response)),
      );
    } catch (e) {
      emit(HomeBannaresErrorState(message: e.toString()));
    }
  }
}
