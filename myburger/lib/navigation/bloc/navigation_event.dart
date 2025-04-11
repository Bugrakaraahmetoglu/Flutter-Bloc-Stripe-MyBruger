part of 'navigation_bloc.dart';

@immutable
sealed class NavigationEvent {}

final class NavigateToHomeEvent extends NavigationEvent {}

final class NavigateToProfileEvent extends NavigationEvent {}

final class NavigateToCartEvent extends NavigationEvent {}

final class NavigateToMessagesEvent extends NavigationEvent {}

final class NavigateToFavoriteEvent extends NavigationEvent {}
