part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignUpClicked extends SignupEvent {
  final String email;
  final String password;
  final String? referralCode;

  SignUpClicked(
      {required this.email, required this.password, this.referralCode});
}

class InputChanged extends SignupEvent {
  final bool formValid;
  final bool referralAvaialble;

  InputChanged({required this.referralAvaialble, required this.formValid});
}
