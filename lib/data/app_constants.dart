import 'dart:math';

import 'package:reaferral_test/router/router.gr.dart';

final appRouter = AppRouter();
String referralCalculationLogic() {
  final rand = Random();
  int _code = rand.nextInt(9999) + 1000;
  return "REF${_code}";
}
