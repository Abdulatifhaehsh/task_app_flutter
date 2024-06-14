import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/api_endpoints.dart';
import 'package:task_app/core/errors/exceptions.dart';
import 'package:task_app/data/datasources/remote/auth_remote_data_source.dart';
import '../../helper/read_json.dart';
import '../../helper/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late AuthRemoteDataSourceImp authRemoteDataSourceImp;

  setUp(() {
    mockHttpClient = MockHttpClient();
    authRemoteDataSourceImp = AuthRemoteDataSourceImp(client: mockHttpClient);
  });

  const testUsername = 'emilys';
  const testPassword = 'emilyspass';

  group('login from datasource', () {
    test('should return user id when the response status code is 200',
        () async {
      // Arrange
      when(mockHttpClient.post(
        Uri.parse(ApiEndpoints.authLogin),
        body: jsonEncode({
          'username': testUsername,
          'password': testPassword,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      )).thenAnswer((_) async => http.Response(
          readJson('helper/dummy_data/dummy_login_response.json'), 200));

      // Act
      final result =
          await authRemoteDataSourceImp.login(testUsername, testPassword);

      // Assert
      expect(result, isA<int>());
    });

    test(
      'should throw a server exception when the response code is 400 or other',
      () async {
        //arrange
        when(mockHttpClient.post(
          Uri.parse(ApiEndpoints.authLogin),
          body: jsonEncode({
            'username': testUsername,
            'password': testPassword,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        )).thenAnswer((_) async => http.Response('Not found', 400));

        //act
        final result =
            authRemoteDataSourceImp.login(testUsername, testPassword);

        //assert
        expect(result, throwsA(isA<ServerException>()));
      },
    );
  });
}
