import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fruits_hub/core/errors/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Sign up + Save user to Firestore
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      /// ❗ نحدّث الـ displayName في Firebase Auth
      await user.updateDisplayName(displayName);

      /// ✅ تخزين بيانات المستخدم في Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': displayName,
        'email': user.email,
        'uId': user.uid,
      });

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw CustomException(message: 'الرقم السري ضعيف.');
        case 'email-already-in-use':
          throw CustomException(message: 'الحساب موجود بالفعل.');
        case 'network-request-failed':
          throw CustomException(message: 'تأكد من اتصالك بالإنترنت.');
        default:
          throw CustomException(message: 'حدث خطأ غير متوقع.');
      }
    }
  }

  /// ✅ Sign in (Email & Password)
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException {
      throw CustomException(message: 'البريد أو الرقم السري غير صحيح.');
    }
  }

  /// ✅ Sign in with Google + Save to Firestore if first login
  Future<User> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw CustomException(message: 'تم إلغاء العملية.');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user!;

      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? "بدون اسم",
        'email': user.email ?? "بدون بريد",
        'uId': user.uid,
      }, SetOptions(merge: true));

      return user;
    } catch (_) {
      throw CustomException(message: 'فشل تسجيل الدخول بواسطة Google.');
    }
  }

  /// ✅ Sign in with Facebook
  Future<User> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      if (result.status != LoginStatus.success) {
        throw CustomException(message: 'فشل تسجيل الدخول بواسطة Facebook.');
      }

      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user!;

      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? "بدون اسم",
        'email': user.email ?? "بدون بريد",
        'uId': user.uid,
      }, SetOptions(merge: true));

      return user;
    } catch (_) {
      throw CustomException(message: 'فشل تسجيل الدخول بواسطة Facebook.');
    }
  }

  /// ✅ Sign in with Apple
  Future<User> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider(
        "apple.com",
      ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

      final userCredential = await _firebaseAuth.signInWithCredential(
        oauthCredential,
      );
      final user = userCredential.user!;

      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? "بدون اسم",
        'email': user.email ?? "بدون بريد",
        'uId': user.uid,
      }, SetOptions(merge: true));

      return user;
    } catch (_) {
      throw CustomException(message: 'فشل تسجيل الدخول بواسطة Apple.');
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String sha256ofString(String input) =>
      sha256.convert(utf8.encode(input)).toString();
}
