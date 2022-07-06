part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeLoaded extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {}
