part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupError extends SignupState {}

class SignupReferralReady extends SignupState {}

class SignupReady extends SignupState {}
