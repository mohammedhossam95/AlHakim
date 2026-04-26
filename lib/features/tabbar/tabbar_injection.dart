import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import '../../injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initTabbarFeatureInjection() async {
  ///-> Cubits
  _sl.registerLazySingleton<BottomNavBarCubit>(() => BottomNavBarCubit());

  ///-> UseCases

  ///-> Repository

  //-> DataSource
}

///-> BlocProvider
List<BlocProvider> get bottomNavBlocs => <BlocProvider>[
  BlocProvider<BottomNavBarCubit>(
    create: (BuildContext context) => _sl<BottomNavBarCubit>(),
  ),
];
