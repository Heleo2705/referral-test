import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:reaferral_test/data/app_constants.dart';
import 'package:reaferral_test/router/router.gr.dart';

import '../../data/repositories/auth_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginClicked>(_loginClickLogic);
    on<TextInputChanged>(_textLogic);
  }
  _loginUser({required String email, required String password}) async {
    final AuthRepo _repo = AuthRepo();
    final _result = await _repo.signIn(
      password: password,
      email: email,
    );
    _result.fold(
      (success) async {
        appRouter.replace(HomeScreenRoute());
      },
      (failure) {
        emit(LoginError());
      },
    );
  }

  _loginClickLogic(LoginClicked event, Emitter<LoginState> emit) {
    if (state is LoginReady) {
      _loginUser(
        email: event.email,
        password: event.password,
      );
    } else {
      emit(LoginError());
    }
  }

  FutureOr<void> _textLogic(TextInputChanged event, Emitter<LoginState> emit) {
    if (event.formValid) {
      emit(LoginReady());
    } else {
      emit(LoginInitial());
    }
  }
}
