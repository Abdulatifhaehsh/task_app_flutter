import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/domain/usecases/task_usecase.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  late AddTaskUseCase addTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    addTaskUseCase = AddTaskUseCase(mockTaskRepository);
  });

  const taskEntity = TaskEntity(
      id: 11,
      todo: "Text a friend I haven't talked to in a long time",
      completed: false,
      userId: 39);

  test('should add task from usecase', () async {
    //arrange
    when(mockTaskRepository.addTask(taskEntity))
        .thenAnswer((_) async => const Right(taskEntity));
    //act
    final result = await addTaskUseCase(taskEntity);
    //assert
    expect(result, const Right(taskEntity));
  });
}
