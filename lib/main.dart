import 'package:flutter/material.dart';
import 'package:todo_app_rest_api/pages/todos/add_todo.dart';
import 'package:todo_app_rest_api/pages/todos/todo_list.dart';
import 'package:todo_app_rest_api/routs/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // home: TodoList(),+
      initialRoute: '/addTodo',
      routes: {
        MainRoute.listTodo: (contex) => const TodoList(),
        MainRoute.addTodo: (contex) => const AddTodo(),
        // MainRoute.loginRoute: (contex) => const LoginPage(),
        // MainRoute.layoutRoute: (contex) => const Layout(),
      },
    );
  }
}
