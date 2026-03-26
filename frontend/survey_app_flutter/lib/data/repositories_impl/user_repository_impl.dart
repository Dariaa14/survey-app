import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:survey_app_flutter/data/entities_impl/user_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/user_entity.dart';
import 'package:survey_app_flutter/domain/repositories/user_repository.dart';

/// Concrete implementation of [UserRepository] that interacts with
class UserRepositoryImpl implements UserRepository {
  /// Base URL for the users API.
  final String baseUrl = 'http://localhost:3000/api/users';

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
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
    final response = await http.get(Uri.parse('$baseUrl/$userId'));
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
      Uri.parse(baseUrl),
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
}
