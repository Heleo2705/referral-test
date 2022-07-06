import 'package:auto_route/auto_route.dart';
import 'package:reaferral_test/presentation/home_screen.dart';
import 'package:reaferral_test/presentation/login_screen.dart';
import 'package:reaferral_test/presentation/sign_up_screen.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  MaterialRoute(page: LoginScreen),
  MaterialRoute(page: HomeScreen),
  MaterialRoute(page: SignUpScreen, initial: true),
])
class $AppRouter {}
