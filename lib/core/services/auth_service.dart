import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    final user = credential.user;
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? _extractNameFromEmail(user.email ?? ''),
      email: user.email ?? '',
      photoUrl: user.photoURL,
      phone: user.phoneNumber,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  String _extractNameFromEmail(String email) {
    if (email.isEmpty) return 'User';
    final local = email.split('@').first;
    return local
        .split(RegExp(r'[._-]'))
        .map((w) => w.isNotEmpty
            ? w[0].toUpperCase() + w.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  UserModel? getCurrentUserModel() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? _extractNameFromEmail(user.email ?? ''),
      email: user.email ?? '',
      photoUrl: user.photoURL,
      phone: user.phoneNumber,
    );
  }
}

