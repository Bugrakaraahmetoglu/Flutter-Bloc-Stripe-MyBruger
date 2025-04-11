import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myburger/model/BurgerData.dart';
import 'package:myburger/model/BurgerModel.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeNavigateToDetailsEvent>(homeNavigateToDetailsEvent);
  }

  FutureOr<void> homeInitialEvent(HomeInitialEvent event, Emitter<HomeState> emit) async {
  
  emit(HomeLoadingState());
  await Future.delayed(const Duration(seconds: 3));
  emit(HomeLoadedSuccessState(burgers.map((e) => BurgerModel(
    id: e.id,
    name: e.name,
    shop: e.shop,
    description: e.description,
    deliveryTime: e.deliveryTime,
    category: e.category,
    rating: e.rating,
    price: e.price,
    imageUrl: e.imageUrl,
  )).toList(
  ),));
  }

  FutureOr<void> homeNavigateToDetailsEvent(HomeNavigateToDetailsEvent event, Emitter<HomeState> emit) {
    print("HomeNavigateToDetailsEvent Clicked");
  emit(HomeNavigateToDetailsState(event.burgerModel));
  
  }
}
