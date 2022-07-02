import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reaferral_test/presentation/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
