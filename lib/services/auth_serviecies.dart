import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthServices {
  Future<bool> loginWithEmailAndPassword(String email, String password);
  Future<bool> registerWithEmailAndPassword(String email, String password);
  Future<bool> authenticateWithGoogle();
  Future<bool> authenticateWithFacebook();
  User? currentUser();
  Future<void> logout();
}

class AuthServicesImpl implements AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;
  bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) {
      return;
    }
    await _googleSignIn.initialize();
    _googleSignInInitialized = true;
  }

  @override
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> authenticateWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      final gUser = await _googleSignIn.authenticate();
      final gAuth = gUser.authentication;
      if (gAuth.idToken == null) {
        throw Exception(
          'Google Sign-In returned no idToken.\n'
          'Fix: In Firebase Console → Authentication → Sign-in method, enable Google.\n'
          'Then in Firebase Console → Project settings → Android app, add SHA-1 for package ecommerce.application and re-download google-services.json.',
        );
      }
      final credential = GoogleAuthProvider.credential(idToken: gAuth.idToken);
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return userCredential.user != null;
    } on PlatformException catch (e) {
      throw Exception(
        'Google Sign-In platform error (${e.code}). ${e.message ?? ''}'.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(
        'FirebaseAuth error (${e.code}). ${e.message ?? ''}'.trim(),
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> authenticateWithFacebook() async {
    try {
      final loginResult = await FacebookAuth.instance.login();
      switch (loginResult.status) {
        case LoginStatus.success:
          break;
        case LoginStatus.cancelled:
          throw Exception('Facebook sign-in cancelled.');
        case LoginStatus.failed:
          throw Exception(loginResult.message ?? 'Facebook sign-in failed.');
        default:
          throw Exception('Facebook sign-in failed: ${loginResult.status}.');
      }

      final token = loginResult.accessToken?.tokenString;
      if (token == null || token.isEmpty) {
        throw Exception(
          'Facebook sign-in returned no access token.\n'
          'Fix: Set the correct Facebook App ID + Client Token in android/app/src/main/res/values/strings.xml, and set App ID + App Secret in Firebase Auth provider settings.',
        );
      }

      final credential = FacebookAuthProvider.credential(token);
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return userCredential.user != null;
    } on PlatformException catch (e) {
      throw Exception(
        'Facebook sign-in platform error (${e.code}). ${e.message ?? ''}'
            .trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(
        'FirebaseAuth error (${e.code}). ${e.message ?? ''}'.trim(),
      );
    }
  }
}
