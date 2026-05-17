import 'package:crypto_oracle/core/errors/app_exception.dart';
import 'package:crypto_oracle/core/storage/secure_storage_service.dart';
import 'package:crypto_oracle/models/auth/auth_request_model.dart';
import 'package:crypto_oracle/models/common/user_model.dart';

class AuthRepository {
  final SecureStorageService _secureStorage;

  AuthRepository(this._secureStorage);

  // Simulated authentication - replace with real API calls
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate validation
      if (request.email.isEmpty || request.password.isEmpty) {
        throw ValidationException(message: 'Email and password are required');
      }

      // Simulate successful login
      final response = AuthResponse(
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_123',
        email: request.email,
        name: 'Demo User',
        message: 'Login successful',
      );

      // Save token
      await _secureStorage.saveAuthToken(response.token);
      await _secureStorage.saveUserId(response.userId);

      return response;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException(message: 'Login failed: ${e.toString()}');
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate validation
      if (request.email.isEmpty ||
          request.password.isEmpty ||
          request.name.isEmpty) {
        throw ValidationException(message: 'All fields are required');
      }

      // Simulate successful registration
      final response = AuthResponse(
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: request.email,
        name: request.name,
        message: 'Registration successful',
      );

      // Save token
      await _secureStorage.saveAuthToken(response.token);
      await _secureStorage.saveUserId(response.userId);

      return response;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException(message: 'Registration failed: ${e.toString()}');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await _secureStorage.getAuthToken();
      final userId = await _secureStorage.getUserId();

      if (token == null || userId == null) {
        return null;
      }

      // Simulate fetching user data
      return UserModel(
        id: userId,
        email: 'user@cryptooracle.com',
        name: 'Demo User',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _secureStorage.clearAll();
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getAuthToken();
    return token != null;
  }
}
