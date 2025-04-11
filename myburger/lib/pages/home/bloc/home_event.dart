part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeNavigateToDetailsEvent extends HomeEvent {
  final BurgerModel burgerModel;

  HomeNavigateToDetailsEvent(this.burgerModel);
}
