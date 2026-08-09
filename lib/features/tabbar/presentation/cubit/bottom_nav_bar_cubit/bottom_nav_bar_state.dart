part of 'bottom_nav_bar_cubit.dart';

class BottomNavBarState extends Equatable {
  final int index;

  /// Increments on every tap so listeners can refresh even when index is unchanged.
  final int tapId;

  const BottomNavBarState({
    this.index = 0,
    this.tapId = 0,
  });

  @override
  List<Object?> get props => [
    index,
    tapId,
  ];
}