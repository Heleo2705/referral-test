import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp.router(
    routerDelegate: appRouter.delegate(),
    routeInformationParser: appRouter.defaultRouteParser(),
  ));
}
