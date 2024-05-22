import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusnest/src/constants/firebase_collection.dart';
import 'package:focusnest/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

// Repository class for handling authentication-related operations using Firebase
class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  // Stream to monitor authentication state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Retrieve the currently signed-in user
  User? get currentUser => _auth.currentUser;

  // Sign in a user with email and password.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Create a new user with the given email and password.
  Future<void> createNewUser({
    required String email,
    required String password,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userId = result.user!.uid;

    final newUser = AppUser(
      id: userId,
      email: email,
      createdDate: DateTime.now(),
    ).toJson();

    await FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .doc(userId)
        .set(newUser);
  }

  // Check if the given email is already in use
  Future<bool> isEmailAlreadyInUse(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  // Validate the current user's password
  Future<bool> validateCurrentPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
      return userCredential.user != null;
    } catch (e) {
      return false;
    }
  }

  // Update the current user's password.
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  // Send email verification to the current user
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Sign out the current user
  Future<void> signOut() {
    return _auth.signOut();
  }

  // Send a password reset email to the given email
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Delete the current user's account
  Future<void> deleteUserAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection(FirebaseCollections.users)
          .doc(user.uid)
          .delete();
      await user.delete();
    }
  }
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
