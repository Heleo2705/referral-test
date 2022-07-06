import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaferral_test/business_logic/home/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = HomeCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc..init(),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome ${_bloc.email}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                            "Here's your referral code - ${_bloc.referral_code}",
                            style: TextStyle(fontSize: 18)),
                        Text("Start referring"),
                      ],
                    );
                  } else if (state is HomeLoading) {
                    return CircularProgressIndicator();
                  } else {
                    return Text("Some Error Occurred");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
