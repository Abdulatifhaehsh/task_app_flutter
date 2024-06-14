import 'package:dartz/dartz.dart';
import 'package:task_app/core/errors/failures.dart';
import 'package:task_app/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Either<Failure, int>> call(String username, String password) {
    return authRepository.login(username, password);
  }
}
