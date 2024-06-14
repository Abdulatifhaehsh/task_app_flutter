import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:task_app/data/models/task_model.dart';
import 'package:task_app/domain/entities/task_entity.dart';

import '../../helper/read_json.dart';

void main() {
  const testTaskModel = TaskModel(
      id: 11,
      todo: 'Text a friend I haven\'t talked to in a long time',
      completed: false,
      userId: 39);

  test('should be a subclass of Task entity', () async {
    // assert
    expect(testTaskModel, isA<TaskEntity>());
  });

  test('should return a valid model from json', () async {
    // arrange
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('helper/dummy_data/dummy_task_response.json'));
    //act
    final result = TaskModel.fromJson(jsonMap);

    //assert
    expect(result, equals(testTaskModel));
  });

  test('should return a json map containing proper data', () async {
    // arrange
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('helper/dummy_data/dummy_task_response.json'));
    //act
    final result = testTaskModel.toJson();

    //assert
    expect(result, equals(jsonMap));
  });
}
