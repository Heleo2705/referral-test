import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reaferral_test/data/models/failure.dart';
import 'package:reaferral_test/data/repositories/db_repo.dart';

abstract class _AuthRepoAbstract {
  Future<Either<UserCredential, Failure>> createUser(
      {required String email, required String password});
  Future<Either<UserCredential, Failure>> signIn(
      {required String email, required String password});
  Future<Either<UserCredential, Failure>> createUserWithReferral(
      {required String referralCode,
      required String email,
      required String password});
}

class AuthRepo extends _AuthRepoAbstract {
  @override
  Future<Either<UserCredential, Failure>> createUser(
      {required String email, required String password}) async {
    try {
      final UserCredential credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final _dbRepo = DbRepo();
      await _dbRepo.assignReferralCode(docPath: credentials.user!.uid);
      return Left(credentials);
    } on Error catch (e, s) {
      return Right(Failure(e.toString()));
    }
  }

  @override
  Future<Either<UserCredential, Failure>> signIn(
      {required String email, required String password}) async {
    try {
      final UserCredential credentials =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Left(credentials);
    } on Error catch (e, s) {
      return Right(Failure(e.toString()));
    }
  }

  @override
  Future<Either<UserCredential, Failure>> createUserWithReferral(
      {required String referralCode,
      required String email,
      required String password}) async {
    try {
      final _repo = DbRepo();
      final _dbResult =
          await _repo.addReferee(referralCode: referralCode, email: email);

      if (_dbResult.isLeft()) {
        final Either<UserCredential, Failure> _result =
            await createUser(email: email, password: password);
        if (_result.isLeft()) {
          return Left(
              _result.swap().getOrElse(() => throw UnimplementedError()));
        } else {
          return Right(
              Failure("User creation failed in Create User with Referral"));
        }
      } else {
        return Right(Failure("Create User with referral Failed"));
      }
    } on Exception catch (e) {
      return Right(Failure("Error in Create User with Referral"));
    }
  }
}
