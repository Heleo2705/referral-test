import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  String referral_code = "";
  String email = "";
  HomeCubit() : super(HomeLoading());
  init() async {
    emit(HomeLoading());
    try {
      final _user = FirebaseAuth.instance.currentUser;
      final _dbReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user?.uid ?? "")
          .get();
      referral_code = _dbReference['referral_code'];
      email = _dbReference['full_name'];
      emit(HomeLoaded());
    } on Exception catch (e) {
      emit(HomeError());
    }
  }
}
