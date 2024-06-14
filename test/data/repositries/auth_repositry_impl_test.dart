import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/core/errors/exceptions.dart';
import 'package:task_app/core/errors/failures.dart';
import 'package:task_app/data/repositories/auth_repository_impl.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepositoryImpl =
        AuthRepositoryImpl(authRemoteDataSource: mockAuthRemoteDataSource);
  });
  const testUsername = 'username';
  const testPassword = 'password';

  group('login repositry', () {
    test('should return user id when a call to data source is successful',
        () async {
      when(mockAuthRemoteDataSource.login(testUsername, testPassword))
          .thenAnswer((_) async => 1);

      final result = await authRepositoryImpl.login(testUsername, testPassword);

      expect(result, equals(const Right(1)));
    });

    test(
        'should return data not found failure when a call to data source is unsuccessful',
        () async {
      when(mockAuthRemoteDataSource.login(testUsername, testPassword))
          .thenThrow(DataNotFoundException());

      final result = await authRepositoryImpl.login(testUsername, testPassword);

      expect(
          result,
          equals(const Left(DataNotFoundFailure(
              "Login failed. Please check your username and password."))));
    });

    test(
        'should return Server failure when a call to data source is unsuccessful',
        () async {
      when(mockAuthRemoteDataSource.login(testUsername, testPassword))
          .thenThrow(ServerException());

      final result = await authRepositoryImpl.login(testUsername, testPassword);

      expect(
          result,
          equals(const Left(
              ServerFailure("There is a problem. Please try again"))));
    });
  });
}
