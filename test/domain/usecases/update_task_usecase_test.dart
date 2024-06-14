import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/domain/usecases/task_usecase.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  late UpdateTaskUseCase updateTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    updateTaskUseCase = UpdateTaskUseCase(mockTaskRepository);
  });

  const taskEntity = TaskEntity(
      id: 11,
      todo: "Text a friend I haven't talked to in a long time",
      completed: true,
      userId: 39);

  test('should update task from usecase', () async {
    //arrange
    when(mockTaskRepository.updateTask(taskEntity))
        .thenAnswer((_) async => const Right(true));
    //act
    final result = await updateTaskUseCase(taskEntity);
    //assert
    expect(result, const Right(true));
  });
}
