import 'package:dartz/dartz.dart';
import 'package:task_app/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, int>> login(String username, String password);
  void logout();
}
