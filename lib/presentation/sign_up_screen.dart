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
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: Scaffold(
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    return Card(
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (v) {
                              final regex =
                                  RegExp(r'^\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b');
                              if (v != null) {
                                if (regex.hasMatch(v) != true) {
                                  return "Please enter a valid email";
                                }
                              }
                            },
                            decoration: InputDecoration(
                              label: Text("Email ID"),
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
                            obscureText: !_showPassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              label: Text("Password"),
                              suffixIcon: InkWell(
                                child: Icon(Icons.visibility),
                                onTap: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                              suffixIconColor:
                                  (!_showPassword) ? Colors.grey : Colors.blue,
                            ),
                            validator: (v) {
                              if (v != null) {
                                if (v.trim().length < 6) {
                                  return "Password should be at least 6 digits long";
                                }
                              }
                            },
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
                      return TextFormField(
                        maxLength: 7,
                        decoration: InputDecoration(
                          label: Text("Referral code"),
                        ),
                        validator: (v) {
                          final regex = RegExp(r'^(REF)[\d]{4}');
                          if (v != null) {
                            if (regex.hasMatch(v) != true) {
                              return "Incorrect Referral Code";
                            }
                          }
                        },
                        onChanged: (v) {
                          referralCode = v;
                          context.read<SignupBloc>().add(
                                InputChanged(
                                  referralAvaialble: referral,
                                  formValid:
                                      _formKey.currentState?.validate() ??
                                          false,
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
      ),
    );
  }
}
