import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/data/datasources/local/task_local_data_source_impl.dart';
import 'package:task_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:task_app/data/datasources/remote/task_remote_data_source_impl.dart';
import 'package:task_app/data/repositories/auth_repository_impl.dart';
import 'package:task_app/data/repositories/task_repository_impl.dart';
import 'package:task_app/domain/usecases/login_usecase.dart';
import 'package:task_app/domain/usecases/task_usecase.dart';
import 'package:task_app/presentation/pages/login_page.dart';
import 'package:task_app/presentation/pages/task_page.dart';
import 'package:task_app/presentation/state_management/provider/auth_provider.dart';
import 'package:task_app/presentation/state_management/provider/task_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final taskRepository = TaskRepositoryImpl(
      remoteDataSource: TaskRemoteDataSourceImpl(client: http.Client()),
      localDataSource: TaskLocalDataSourceImpl(),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            loginUseCase: LoginUseCase(AuthRepositoryImpl(
                authRemoteDataSource:
                    AuthRemoteDataSourceImp(client: http.Client()))),
          ),
        ),
        ChangeNotifierProvider(
            create: (_) => TaskProvider(
                  fetchTasksUseCase: FetchTasksUseCase(taskRepository),
                  addTaskUseCase: AddTaskUseCase(taskRepository),
                  updateTaskUseCase: UpdateTaskUseCase(taskRepository),
                  deleteTaskUseCase: DeleteTaskUseCase(taskRepository),
                )),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const TaskPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
