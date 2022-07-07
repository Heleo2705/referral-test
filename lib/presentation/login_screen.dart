import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaferral_test/data/app_constants.dart';
import 'package:reaferral_test/router/router.gr.dart';

import '../business_logic/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<LoginBloc, LoginState>(
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
                              label: Text("Username"),
                            ),
                            onChanged: (v) {
                              email = v;
                              context.read<LoginBloc>().add(
                                    TextInputChanged(
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
                              context.read<LoginBloc>().add(
                                    TextInputChanged(
                                      formValid:
                                          _formKey.currentState?.validate() ??
                                              false,
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(
                                LoginClicked(email: email, password: password));
                          },
                          child: Text("Login"),
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        appRouter.replace(SignUpScreenRoute());
                      },
                      child: Text("Or Signup?"),
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
