import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  Exception _requestFailed(
    String operation,
    int statusCode,
    String body,
  ) {
    return Exception(
      '$operation failed (HTTP $statusCode). Response: $body',
    );
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      final response = await http
          .get(Uri.parse(baseUsersUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map(
              (json) => UserEntityImpl.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }

      throw _requestFailed(
        'Fetching users',
        response.statusCode,
        response.body,
      );
    } on SocketException catch (e) {
      throw Exception('Network error while fetching users: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('HTTP error while fetching users: ${e.message}');
    } on FormatException {
      throw Exception('Invalid users payload format from server.');
    }
  }

  @override
  Future<UserEntity> getUserById(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUsersUrl/$userId'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return UserEntityImpl.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }

      throw _requestFailed('Fetching user', response.statusCode, response.body);
    } on SocketException catch (e) {
      throw Exception('Network error while fetching user: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('HTTP error while fetching user: ${e.message}');
    } on FormatException {
      throw Exception('Invalid user payload format from server.');
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    try {
      final response = await http
          .post(
            Uri.parse(baseUsersUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode((user as UserEntityImpl).toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserEntityImpl.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }

      throw _requestFailed('Creating user', response.statusCode, response.body);
    } on SocketException catch (e) {
      throw Exception('Network error while creating user: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('HTTP error while creating user: ${e.message}');
    } on FormatException {
      throw Exception('Invalid create-user payload format from server.');
    } catch (e) {
      throw Exception('Unexpected error while creating user: $e');
    }
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/users/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String?;
        if (token == null || token.isEmpty) {
          throw Exception('Login succeeded but token is missing in response.');
        }

        await _storage.write(key: 'auth_token', value: token);
        return true;
      }

      if (response.statusCode == 400 || response.statusCode == 401) {
        return false;
      }

      throw _requestFailed('Login', response.statusCode, response.body);
    } on TimeoutException {
      throw Exception(
        'Timeout while logging in (POST $baseUrl/api/users/login).',
      );
    } on SocketException catch (e) {
      throw Exception('Network error while logging in: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('HTTP error while logging in: ${e.message}');
    } on FormatException {
      throw Exception('Invalid login payload format from server.');
    } catch (e) {
      throw Exception('Unexpected error while logging in: $e');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return _storage.read(key: 'auth_token');
    } catch (_) {
      throw Exception('Failed to read auth token from secure storage.');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available. Please login again.');
      }

      final response = await http
          .get(
            Uri.parse('$baseUsersUrl/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return UserEntityImpl.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }

      throw _requestFailed(
        'Fetching current user',
        response.statusCode,
        response.body,
      );
    } on TimeoutException {
      throw Exception(
        'Timeout while fetching current user (GET $baseUsersUrl/me).',
      );
    } on SocketException catch (e) {
      throw Exception(
        'Network error while fetching current user: ${e.message}',
      );
    } on HttpException catch (e) {
      throw Exception('HTTP error while fetching current user: ${e.message}');
    } on FormatException {
      throw Exception('Invalid current-user payload format from server.');
    } catch (e) {
      throw Exception('Unexpected error while fetching current user: $e');
    }
  }

  @override
  Future<bool> isCurrentUserAdmin() async {
    final currentUser = await getCurrentUser();
    return currentUser.type == UserType.admin;
  }

  @override
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
    } catch (_) {
      throw Exception('Failed to clear auth token from secure storage.');
    }
  }
}
