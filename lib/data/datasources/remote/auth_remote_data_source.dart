import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/api_endpoints.dart';
import 'package:task_app/core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<int> login(String username, String password);
}

class AuthRemoteDataSourceImp extends AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImp({required this.client});

  @override
  Future<int> login(String username, String password) async {
    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.authLogin),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['id'] as int;
      } else {
        throw DataNotFoundException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
