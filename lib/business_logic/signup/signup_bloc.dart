import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reaferral_test/data/app_constants.dart';
import 'package:reaferral_test/data/repositories/auth_repo.dart';
import 'package:reaferral_test/router/router.gr.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<InputChanged>(_inputLogic);
    on<SignUpClicked>(_signupLogic);
  }

  FutureOr<void> _inputLogic(InputChanged event, Emitter<SignupState> emit) {
    if (event.formValid && !event.referralAvaialble) {
      emit(SignupReady());
    } else if (event.formValid && event.formValid) {
      emit(SignupReferralReady());
    } else {
      emit(SignupInitial());
    }
  }

  FutureOr<void> _signupLogic(
      SignUpClicked event, Emitter<SignupState> emit) async {
    final _repo = AuthRepo();
    if (state is SignupReferralReady) {
      final _result = await _repo.createUserWithReferral(
        referralCode: event.referralCode!,
        password: event.password,
        email: event.email,
      );
      _result.fold((l) => appRouter.replace(HomeScreenRoute()), (r) => null);
    } else if (state is SignupReady) {
      final result = await _repo.createUser(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (success) {
          print("User created");
          appRouter.replace(HomeScreenRoute());
        },
        (fail) => print("User Sign up failed"),
      );
    }
  }
}
