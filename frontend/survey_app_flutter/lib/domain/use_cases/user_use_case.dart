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
  Future<UserEntity> createUser(UserEntity user) async {
    return _userRepository.createUser(user);
  }
}
