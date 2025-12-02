import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruits_hub/constants.dart';
import 'package:fruits_hub/core/errors/exceptions.dart';
import 'package:fruits_hub/core/errors/failures.dart';
import 'package:fruits_hub/core/services/data_service.dart';
import 'package:fruits_hub/core/services/firebase_auth_service.dart';
import 'package:fruits_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruits_hub/core/utils/backend_endpoint.dart';
import 'package:fruits_hub/features/auth/data/models/user_model.dart';
import 'package:fruits_hub/features/auth/domain/entites/user_entity.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;

  AuthRepoImpl({
    required this.databaseService,
    required this.firebaseAuthService,
  });

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    User? user;
    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: name, // ✅ إرسال الاسم هنا
      );

      final userEntity = UserEntity(name: name, email: email, uId: user.uid);

      await addUserData(user: userEntity);
      await saveUserData(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      await deleteUser(user);
      return left(ServerFailure(e.message));
    } catch (e, st) {
      await deleteUser(user);
      log('Exception in AuthRepoImpl.createUserWithEmailAndPassword: $e\n$st');
      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
    }
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      try {
        await user.delete(); // ✅ الحل الصحيح
      } catch (e) {
        log('Error deleting user: $e');
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userEntity = await getUserData(uid: user.uid);
      await saveUserData(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e, st) {
      log('Exception in AuthRepoImpl.signinWithEmailAndPassword: $e\n$st');
      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();
      final userModel = UserModel.fromFirebaseUser(user);
      UserEntity userEntity = userModel.toEntity();

      final isUserExist = await databaseService.checkIfDataExists(
        path: BackendEndpoint.isUserExists,
        documentId: user.uid,
      );

      if (isUserExist) {
        userEntity = await getUserData(uid: user.uid);
      } else {
        await addUserData(user: userEntity);
      }

      await saveUserData(user: userEntity);
      return right(userEntity);
    } catch (e, st) {
      await deleteUser(user);
      log('Exception in AuthRepoImpl.signinWithGoogle: $e\n$st');
      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithFacebook();
      final userModel = UserModel.fromFirebaseUser(user);
      UserEntity userEntity = userModel.toEntity();

      final isUserExist = await databaseService.checkIfDataExists(
        path: BackendEndpoint.isUserExists,
        documentId: user.uid,
      );

      if (isUserExist) {
        userEntity = await getUserData(uid: user.uid);
      } else {
        await addUserData(user: userEntity);
      }

      await saveUserData(user: userEntity);
      return right(userEntity);
    } catch (e, st) {
      await deleteUser(user);
      log('Exception in AuthRepoImpl.signinWithFacebook: $e\n$st');
      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithApple() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithApple();
      final userModel = UserModel.fromFirebaseUser(user);
      UserEntity userEntity = userModel.toEntity();

      final isUserExist = await databaseService.checkIfDataExists(
        path: BackendEndpoint.isUserExists,
        documentId: user.uid,
      );

      if (isUserExist) {
        userEntity = await getUserData(uid: user.uid);
      } else {
        await addUserData(user: userEntity);
      }

      await saveUserData(user: userEntity);
      return right(userEntity);
    } catch (e, st) {
      await deleteUser(user);
      log('Exception in AuthRepoImpl.signinWithApple: $e\n$st');
      return left(ServerFailure('حدث خطأ ما. الرجاء المحاولة مرة أخرى.'));
    }
  }

  @override
  Future<void> addUserData({required UserEntity user}) async {
    try {
      await databaseService.addData(
        path: BackendEndpoint.addUserData,
        data: UserModel.fromEntity(user).toMap(),
        documentId: user.uId,
      );
    } catch (e) {
      log('Error adding user data: $e');
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    try {
      final userData = await databaseService.getData(
        path: BackendEndpoint.getUsersData,
        documentId: uid,
      );

      if (userData == null) throw Exception('User not found');

      if (userData is Map<String, dynamic>) {
        return UserModel.fromJson(userData).toEntity();
      }

      if (userData is List && userData.isNotEmpty) {
        final first = userData.first;
        return UserModel.fromJson(Map<String, dynamic>.from(first)).toEntity();
      }

      throw Exception('Invalid user data format');
    } catch (e) {
      log('Error getting user data: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveUserData({required UserEntity user}) async {
    try {
      final jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
      await Prefs.setString(kUserData, jsonData);
    } catch (e) {
      log('Error saving user data to SharedPreferences: $e');
      rethrow;
    }
  }
}
