import 'package:survey_app_flutter/domain/entities/user_entity.dart';

/// Repository interface for user-related data operations.
abstract class UserRepository {
  /// Fetches all users from the data source.
  Future<List<UserEntity>> getAllUsers();

  /// Fetches user information by their unique identifier.
  Future<UserEntity> getUserById(String userId);

  /// Creates a new user in the data source.
  Future<UserEntity> createUser(UserEntity user);

  /// Authenticates a user with their email and password.
  Future<bool> login(String email, String password);

  /// Retrieves the stored authentication token, if available.
  Future<String?> getAuthToken();

  /// Logs out the current user by clearing stored authentication data.
  Future<void> logout();
}
