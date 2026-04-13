import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:survey_app_flutter/data/entities_impl/email_contact_entity_impl.dart';
import 'package:survey_app_flutter/data/entities_impl/email_list_csv_import_result_entity_impl.dart';
import 'package:survey_app_flutter/data/entities_impl/email_list_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/email_contact_entity.dart';
import 'package:survey_app_flutter/domain/entities/email_list_csv_import_result_entity.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/domain/repositories/email_list_repository.dart';

/// Concrete implementation of [EmailListRepository] that interacts with
/// email list REST API endpoints.
class EmailListRepositoryImpl implements EmailListRepository {
  /// Base URL for email list endpoints.
  final String baseUrl =
      'https://survey-app-trusca-daria.onrender.com/api/email-lists';

  @override
  Future<List<EmailListEntity>> getEmailListsByUser({
    required String ownerId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$ownerId'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map(
            (json) =>
                EmailListEntityImpl.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }

    throw Exception('Failed to fetch user email lists: ${response.body}');
  }

  @override
  Future<EmailListEntity> getEmailListById({
    required String listId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$listId'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return EmailListEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Failed to fetch email list: ${response.body}');
  }

  @override
  Future<EmailListEntity> createEmailList({
    required String token,
    required String ownerId,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers(token),
      body: jsonEncode({
        'owner_id': ownerId,
        'name': name,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EmailListEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Failed to create email list: ${response.body}');
  }

  @override
  Future<EmailListEntity> updateEmailList({
    required String token,
    required String listId,
    required String name,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$listId'),
      headers: _headers(token),
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200) {
      return EmailListEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Failed to update email list: ${response.body}');
  }

  @override
  Future<void> deleteEmailList({
    required String token,
    required String listId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$listId'),
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete email list: ${response.body}');
    }
  }

  @override
  Future<EmailContactEntity> createContact({
    required String token,
    required String listId,
    required String email,
    String? name,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$listId/contacts'),
      headers: _headers(token),
      body: jsonEncode({
        'email': email,
        if (name != null && name.isNotEmpty) 'name': name,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EmailContactEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Failed to create contact: ${response.body}');
  }

  @override
  Future<EmailContactEntity> updateContact({
    required String token,
    required String listId,
    required String contactId,
    required String email,
    String? name,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$listId/contacts/$contactId'),
      headers: _headers(token),
      body: jsonEncode({
        'email': email,
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      return EmailContactEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Failed to update contact: ${response.body}');
  }

  @override
  Future<void> deleteContact({
    required String token,
    required String listId,
    required String contactId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$listId/contacts/$contactId'),
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete contact: ${response.body}');
    }
  }

  @override
  Future<EmailListCsvImportResultEntity> importContactsCsv({
    required String token,
    required String listId,
    required String fileName,
    required List<int> csvBytes,
    required bool preview,
  }) async {
    final uri = Uri.parse('$baseUrl/$listId/contacts/import-csv').replace(
      queryParameters: <String, String>{
        'preview': preview.toString(),
      },
    );

    final request =
        http.MultipartRequest(
            'POST',
            uri,
          )
          ..headers['Authorization'] = 'Bearer $token'
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              csvBytes,
              filename: fileName,
            ),
          );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to import CSV contacts: ${response.body}');
    }

    return EmailListCsvImportResultEntityImpl.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
