import 'package:ai_sign_language_recognition/common/exceptions/auth_exceptions.dart';
import 'package:ai_sign_language_recognition/firebase_options.dart';
import 'package:ai_sign_language_recognition/models/cloud_db_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthRepository {
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<CloudUserModel> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = getCurrentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotSignedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "weak-password":
          throw WeakPasswordAuthException();
        case "email-already-in-use":
          throw EmailAlreadyInUseAuthException();
        case "invalid-email":
          throw InvalidEmailAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<CloudUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      credential.user!.updateDisplayName("displayName");
      //user.updateDisplayName(displayName)
      final user = getCurrentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotSignedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          throw UserNotFoundAuthException();
        case "invalid-email":
          throw InvalidEmailAuthException();
        case "user-disabled":
          throw UserDisabledAuthException();
        case "wrong-password":
          throw WrongPasswordAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<void> signOut() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseAuth.instance.signOut();
    } else {
      throw UserNotSignedInAuthException();
    }
  }

  CloudUserModel? get getCurrentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return CloudUserModel.fromFirebaseAuth(user);
    } else {
      return null;
    }
  }

  Future<void> refreshCurrentUser() async {

    await FirebaseAuth.instance.currentUser!.reload();
  }



  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotFoundAuthException();
    }
  }

  Future<void> sendPasswordReset({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "auth/invalid-email":
          throw InvalidEmailAuthException();
        case "auth/user-not-found":
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
