import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:survey_app_flutter/data/entities_impl/user_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/user_entity.dart';
import 'package:survey_app_flutter/domain/repositories/user_repository.dart';

/// Concrete implementation of [UserRepository] that interacts with
class UserRepositoryImpl implements UserRepository {
  final _storage = const FlutterSecureStorage();

  /// Base URL for the users API.
  final String baseUsersUrl = 'http://localhost:3000/api/users';

  /// Base URL for the authentication API.
  final String baseUrl = 'http://localhost:3000';

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final response = await http.get(Uri.parse(baseUsersUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map(
            (json) => UserEntityImpl.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  @override
  Future<UserEntity> getUserById(String userId) async {
    final response = await http.get(Uri.parse('$baseUsersUrl/$userId'));
    if (response.statusCode == 200) {
      return UserEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    final response = await http.post(
      Uri.parse(baseUsersUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode((user as UserEntityImpl).toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to create user');
    }
  }

  @override
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['token'] as String;
      await _storage.write(key: 'auth_token', value: token);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String?> getAuthToken() async {
    return _storage.read(key: 'auth_token');
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}
