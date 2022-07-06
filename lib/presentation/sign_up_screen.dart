import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaferral_test/business_logic/signup/signup_bloc.dart';
import 'package:reaferral_test/data/app_constants.dart';
import 'package:reaferral_test/router/router.gr.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool referral = false;
  String email = "";
  String password = "";
  String referralCode = "";

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: Scaffold(
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<SignupBloc, SignupState>(
                builder: (context, state) {
                  return Card(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text("Username"),
                          ),
                          onChanged: (v) {
                            email = v;
                            context.read<SignupBloc>().add(
                                  InputChanged(
                                    referralAvaialble: referral,
                                    formValid:
                                        _formKey.currentState?.validate() ??
                                            false,
                                  ),
                                );
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text("Password"),
                          ),
                          onChanged: (v) {
                            password = v;
                            context.read<SignupBloc>().add(
                                  InputChanged(
                                    referralAvaialble: referral,
                                    formValid:
                                        _formKey.currentState?.validate() ??
                                            false,
                                  ),
                                );
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
              CheckboxListTile(
                value: referral,
                onChanged: (v) {
                  setState(() {
                    referral = !referral;
                  });
                },
                title: Text("have a referral code?"),
              ),
              if (referral)
                BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    return TextField(
                      decoration: InputDecoration(
                        label: Text("Referral code"),
                      ),
                      onChanged: (v) {
                        referralCode = v;
                        context.read<SignupBloc>().add(
                              InputChanged(
                                referralAvaialble: referral,
                                formValid:
                                    _formKey.currentState?.validate() ?? false,
                              ),
                            );
                      },
                    );
                  },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocBuilder<SignupBloc, SignupState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (referralCode.isEmpty) {
                            context.read<SignupBloc>().add(SignUpClicked(
                                email: email, password: password));
                          } else {
                            context.read<SignupBloc>().add(SignUpClicked(
                                email: email,
                                password: password,
                                referralCode: referralCode));
                          }
                        },
                        child: Text("Sign Up"),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      appRouter.replace(LoginScreenRoute());
                    },
                    child: Text("Or Login?"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
