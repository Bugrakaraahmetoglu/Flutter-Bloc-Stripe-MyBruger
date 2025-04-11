part of 'navigation_bloc.dart';

@immutable
sealed class NavigationState {}

final class NavigationInitial extends NavigationState {}

final class NavigationHomeState extends NavigationState {}

final class NavigationProfileState extends NavigationState {}

final class NavigationCartState extends NavigationState {}

final class NavigationMessagesState extends NavigationState {}

final class NavigationFavoriteState extends NavigationState {}
