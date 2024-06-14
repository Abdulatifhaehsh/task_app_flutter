import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/domain/usecases/task_usecase.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  late DeleteTaskUseCase deleteTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    deleteTaskUseCase = DeleteTaskUseCase(mockTaskRepository);
  });

  const taskEntity = TaskEntity(
      id: 11,
      todo: "Text a friend I haven't talked to in a long time",
      completed: true,
      userId: 39);

  test('should delete task from usecase', () async {
    //arrange
    when(mockTaskRepository.deleteTask(taskEntity.id))
        .thenAnswer((_) async => const Right(true));
    //act
    final result = await deleteTaskUseCase(taskEntity.id);
    //assert
    expect(result, const Right(true));
  });
}
