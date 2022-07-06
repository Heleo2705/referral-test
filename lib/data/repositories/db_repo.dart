import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:reaferral_test/data/app_constants.dart';

import '../models/failure.dart';

abstract class _DpAbstractRepo {
  Future<Either<DocumentReference, Failure>> assignReferralCode(
      {required String docPath});
  Future<Either<DocumentReference, Failure>> findReferrer(
      {required String referralCode});
  Future<Either<DocumentReference, Failure>> addReferee(
      {required String referralCode, required String email});
}

class DbRepo extends _DpAbstractRepo {
  @override
  Future<Either<DocumentReference, Failure>> assignReferralCode(
      {required String docPath}) async {
    try {
      final referralCode = referralCalculationLogic();
      final DocumentReference<Map<String, dynamic>> userDocument =
          FirebaseFirestore.instance.collection('users').doc(docPath);
      await userDocument
          .set({'full_name': 'Nishaant Veer', 'referral_code': referralCode});
      return Left(userDocument);
    } on Error catch (e, s) {
      return Right(Failure(e.toString()));
    }
  }

  @override
  Future<Either<DocumentReference<Object?>, Failure>> findReferrer(
      {required String referralCode}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection('users')
          .where('referral_code', isEqualTo: referralCode)
          .get();
      if (result.docs.isNotEmpty) {
        return Left(result.docs.first.reference);
      } else {
        return Right(Failure("No such referral code exists"));
      }
    } on Exception catch (e) {
      return Right(Failure("No Such referral code exists"));
    }
  }

  @override
  Future<Either<DocumentReference, Failure>> addReferee(
      {required String referralCode, required String email}) async {
    try {
      final referrer = await findReferrer(referralCode: referralCode);
      DocumentReference? result;
      if (referrer.isLeft()) {
        result = await FirebaseFirestore.instance
            .collection('users')
            .doc(referrer.swap().getOrElse(() => throw UnimplementedError()).id)
            .collection('referees')
            .add({'name': email});
        return Left(result);
      } else {
        return Right(Failure("Cant add the referree"));
      }
    } on Exception catch (e) {
      return Right(Failure("No Such referral Code found"));
    }
  }
}
