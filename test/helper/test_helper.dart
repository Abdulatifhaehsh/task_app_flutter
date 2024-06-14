import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:task_app/data/datasources/local/task_local_data_source.dart';
import 'package:task_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:task_app/data/datasources/remote/task_remote_data_source.dart';
import 'package:task_app/domain/repositories/auth_repository.dart';
import 'package:task_app/domain/repositories/task_repository.dart';

@GenerateMocks(
  [
    AuthRepository,
    AuthRemoteDataSource,
    TaskRepository,
    TaskRemoteDataSource,
    TaskLocalDataSource
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
