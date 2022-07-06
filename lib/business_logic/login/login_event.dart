part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginClicked extends LoginEvent {
  final String email;
  final String password;

  LoginClicked({required this.email, required this.password});
}

class TextInputChanged extends LoginEvent {
  final bool formValid;

  TextInputChanged({required this.formValid});
}
