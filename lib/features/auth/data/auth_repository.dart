import 'package:firebase_auth/firebase_auth.dart';

import 'package:crypto_oracle/core/errors/app_exception.dart';
import 'package:crypto_oracle/core/storage/secure_storage_service.dart';
import 'package:crypto_oracle/models/auth/auth_request_model.dart';
import 'package:crypto_oracle/models/common/user_model.dart';

class AuthRepository {
  final SecureStorageService _secureStorage;
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._secureStorage, {FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AuthResponse> login(LoginRequest request) async {
    if (request.email.isEmpty || request.password.isEmpty) {
      throw ValidationException(message: 'Email and password are required');
    }
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: request.email.trim(),
        password: request.password,
      );
      final user = credential.user;
      if (user == null) {
        throw AuthException(message: 'Login failed: no user returned');
      }

      final token = await user.getIdToken() ?? '';
      await _secureStorage.saveAuthToken(token);
      await _secureStorage.saveUserId(user.uid);

      return AuthResponse(
        token: token,
        userId: user.uid,
        email: user.email ?? request.email,
        name: user.displayName ?? user.email?.split('@').first ?? 'User',
        message: 'Login successful',
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e, defaultMessage: 'Login failed');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException(message: 'Login failed: ${e.toString()}');
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    if (request.email.isEmpty ||
        request.password.isEmpty ||
        request.name.isEmpty) {
      throw ValidationException(message: 'All fields are required');
    }
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: request.email.trim(),
        password: request.password,
      );
      final user = credential.user;
      if (user == null) {
        throw AuthException(message: 'Registration failed: no user returned');
      }

      await user.updateDisplayName(request.name);
      await user.reload();
      final refreshed = _firebaseAuth.currentUser ?? user;

      final token = await refreshed.getIdToken() ?? '';
      await _secureStorage.saveAuthToken(token);
      await _secureStorage.saveUserId(refreshed.uid);

      return AuthResponse(
        token: token,
        userId: refreshed.uid,
        email: refreshed.email ?? request.email,
        name: refreshed.displayName ?? request.name,
        message: 'Registration successful',
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e, defaultMessage: 'Registration failed');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException(message: 'Registration failed: ${e.toString()}');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final token = await user.getIdToken();
      if (token != null) {
        await _secureStorage.saveAuthToken(token);
        await _secureStorage.saveUserId(user.uid);
      }
    } catch (_) {
    }

    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? user.email?.split('@').first ?? 'User',
      avatarUrl: user.photoURL,
      createdAt: user.metadata.creationTime,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _secureStorage.clearAll();
  }

  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  AppException _mapFirebaseAuthException(
    FirebaseAuthException e, {
    required String defaultMessage,
  }) {
    switch (e.code) {
      case 'invalid-email':
        return ValidationException(message: 'Invalid email address', code: e.code);
      case 'user-disabled':
        return AuthException(message: 'This account has been disabled', code: e.code);
      case 'user-not-found':
        return AuthException(message: 'No account found for this email', code: e.code);
      case 'wrong-password':
      case 'invalid-credential':
        return AuthException(message: 'Incorrect email or password', code: e.code);
      case 'email-already-in-use':
        return ValidationException(message: 'An account already exists for this email', code: e.code);
      case 'weak-password':
        return ValidationException(message: 'Password is too weak (min 6 characters)', code: e.code);
      case 'operation-not-allowed':
        return AuthException(message: 'Email/password sign-in is not enabled', code: e.code);
      case 'too-many-requests':
        return AuthException(message: 'Too many attempts. Try again later.', code: e.code);
      case 'network-request-failed':
        return NetworkException(message: 'Network error. Check your connection.', code: e.code);
      default:
        return AuthException(
          message: '$defaultMessage: ${e.message ?? e.code}',
          code: e.code,
        );
    }
  }
}
