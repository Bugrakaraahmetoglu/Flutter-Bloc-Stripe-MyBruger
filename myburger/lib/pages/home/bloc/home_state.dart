part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeInitial extends HomeState {}

abstract class HomeActionState extends HomeState{}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<BurgerModel> burgers;

  HomeLoadedSuccessState(this.burgers);
}

class HomeErrorState extends HomeState{}

class HomeNavigateToDetailsState extends HomeActionState {
  final BurgerModel burgerModel;

  HomeNavigateToDetailsState(this.burgerModel);
}



