import 'package:survey_app_flutter/domain/entities/user_entity.dart';
import 'package:survey_app_flutter/domain/repositories/user_repository.dart';

/// Use case for user-related operations.
class UserUseCase {
  final UserRepository _userRepository;

  /// Constructs a [UserUseCase] with the given [UserRepository].
  UserUseCase(UserRepository userRepository) : _userRepository = userRepository;

  /// Fetches all users.
  Future<List<UserEntity>> getAllUsers() async {
    return _userRepository.getAllUsers();
  }

  /// Fetches a user by their unique identifier.
  Future<UserEntity> getUserById(String userId) async {
    return _userRepository.getUserById(userId);
  }

  /// Creates a new user.
  Future<UserEntity> createUser(String email, String password) async {
    return _userRepository.createUser(email, password);
  }

  /// Authenticates a user with their email and password.
  Future<bool> login(String email, String password) async {
    return _userRepository.login(email, password);
  }

  /// Retrieves the stored authentication token, if available.
  Future<String?> getAuthToken() async {
    return _userRepository.getAuthToken();
  }

  /// Fetches the currently authenticated user.
  Future<UserEntity> getCurrentUser() async {
    return _userRepository.getCurrentUser();
  }

  /// Returns whether the current authenticated user is admin.
  Future<bool> isCurrentUserAdmin() async {
    return _userRepository.isCurrentUserAdmin();
  }

  /// Logs out the current user by clearing stored authentication data.
  Future<void> logout() async {
    return _userRepository.logout();
  }
}
