import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/domain/usecases/task_usecase.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  late FetchTasksUseCase fetchTasksUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    fetchTasksUseCase = FetchTasksUseCase(mockTaskRepository);
  });

  const testTasks = [
    TaskEntity(
        id: 11,
        todo: "Text a friend I haven't talked to in a long time",
        completed: false,
        userId: 39),
    TaskEntity(
      id: 12,
      todo: "do tasks",
      completed: false,
      userId: 39,
    ),
  ];

  test('should fetch task from usecase', () async {
    when(mockTaskRepository.fetchTasks(0))
        .thenAnswer((_) async => const Right(testTasks));

    final result = await fetchTasksUseCase(0);

    expect(result, const Right(testTasks));
  });
}
