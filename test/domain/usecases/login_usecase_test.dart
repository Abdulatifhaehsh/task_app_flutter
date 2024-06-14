import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/domain/usecases/login_usecase.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  const testUserId = 1;

  const testUsername = 'emilys';
  const testPassword = 'emilysPass';

  test('should login and get user id from usecase', () async {
    //arrange
    when(mockAuthRepository.login(testUsername, testPassword))
        .thenAnswer((_) async => const Right(testUserId));
    //act
    final result = await loginUseCase(testUsername, testPassword);
    //assert
    expect(result, const Right(testUserId));
  });
}
