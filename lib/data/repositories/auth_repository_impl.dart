import 'package:dartz/dartz.dart';

import 'package:task_app/core/errors/exceptions.dart';
import 'package:task_app/core/errors/failures.dart';
import 'package:task_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:task_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl({
    required this.authRemoteDataSource,
  });
  @override
  Future<Either<Failure, int>> login(String username, String password) async {
    try {
      final result = await authRemoteDataSource.login(username, password);
      return Right(result);
    } on DataNotFoundException {
      return left(const DataNotFoundFailure(
          'Login failed. Please check your username and password.'));
    } on ServerException {
      return left(const ServerFailure('There is a problem. Please try again'));
    }
  }

  @override
  void logout() {}
}
