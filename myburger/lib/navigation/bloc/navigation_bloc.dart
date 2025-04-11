import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigateToHomeEvent>(navigateToHomeEvent);
    on<NavigateToProfileEvent>(navigateToProfileEvent);
    on<NavigateToCartEvent>(navigateToCartEvent);
    on<NavigateToMessagesEvent>(navigateToMessagesEvent);
    on<NavigateToFavoriteEvent>(navigateToFavoriteEvent);
  }

  FutureOr<void> navigateToHomeEvent(NavigateToHomeEvent event, Emitter<NavigationState> emit) {
    emit(NavigationHomeState());
  }

  FutureOr<void> navigateToProfileEvent(NavigateToProfileEvent event, Emitter<NavigationState> emit) {
    emit(NavigationProfileState());
  }

  FutureOr<void> navigateToCartEvent(NavigateToCartEvent event, Emitter<NavigationState> emit) {
    emit(NavigationCartState());
  }

  FutureOr<void> navigateToMessagesEvent(NavigateToMessagesEvent event, Emitter<NavigationState> emit) {
    emit(NavigationMessagesState());
  }

  FutureOr<void> navigateToFavoriteEvent(NavigateToFavoriteEvent event, Emitter<NavigationState> emit) {
    emit(NavigationFavoriteState());
  }
}
